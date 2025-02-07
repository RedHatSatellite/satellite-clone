import yaml
import re
from ansible.module_utils.basic import *


# module: parse_backup_metadata
# description:
#    - Return the Satellite version and Puppet version
#      specified in a Satellite backup
# notes:
#    - The Satellite version is determined from the Satellite rpm
#      version using the backup's rpm list from metadata.yml
#    - The puppet version is determined from the presence of
#      puppet and puppet-agent rpms
# options:
#    metadata_path:
#        description:
#          - Full path (including file name) to metadata.yml
#        required: true

MINIMUM_SUPPORTED_VERSION = (6, 12)

def find_rpm(rpms, pattern):
    rpm_pattern = re.compile(pattern)
    matches = [r for r in rpms if rpm_pattern.match(r)]
    if matches:
        return matches[0]
    else:
        return False


def get_rpm_version(rpms, pattern, hyphen_split=1, version_split=2):
    rpm = find_rpm(rpms, pattern)
    if rpm:
        rpm_version = rpm.split("-")[hyphen_split]
        return '.'.join(rpm_version.split('.')[0:version_split])
    else:
        return False


def parse_backup_metadata(params):
    with open(params["metadata_path"]) as data_file:
        data = yaml.safe_load(data_file)

    rpm_key = ":rpms" if ":rpms" in data else "rpms"
    rpms = data[rpm_key]
    satellite_version = get_rpm_version(rpms, "^satellite-[\d+].*")
    puppetserver_present = bool(find_rpm(rpms, "^puppetserver-[\d+].*"))
    qpidd_present = bool(find_rpm(rpms, "^qpid-cpp-server-[\d+].*"))

    hostname = data['hostname']
    proxy_config = data['proxy_config']

    if not satellite_version:
        satellite_version = os.getenv('SATELLITE_CLONE_FORCE_VERSION')

    if not satellite_version or tuple(int(x) for x in satellite_version.split('.')) < MINIMUM_SUPPORTED_VERSION:
        msg = "Satellite version {0} is not supported or found. " \
              "Only Satellite {1} or newer is supported.".format(satellite_version, '.'.join(str(x) for x in MINIMUM_SUPPORTED_VERSION))
        return False, dict(msg=msg)

    msg = "{0} backup found".format(satellite_version)
    result = dict(satellite_version=satellite_version,
                  puppetserver_present=puppetserver_present,
                  qpidd_present=qpidd_present,
                  hostname=hostname,
                  proxy_config=proxy_config,
                  msg=msg,
                  changed=False)
    return True, result


def main():
    fields = {
        "metadata_path": {"required": True, "type": "str"}
    }

    module = AnsibleModule(argument_spec=fields)
    success, result = parse_backup_metadata(module.params)
    if success:
        module.exit_json(**result)
    else:
        module.fail_json(**result)


if __name__ == '__main__':
    main()
