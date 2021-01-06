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

SUPPORTED_VERSIONS = ["6.5", "6.6", "6.7", "6.8"]

def find_rpm(rpms, pattern):
    matches = [r for r in rpms if pattern.match(r)]
    if len(matches) > 0:
        return matches[0]
    else:
        return False


def get_rpm_version(rpms, pattern, hyphen_split=1, version_split=2):
    rpm_pattern = re.compile(pattern)
    rpm = find_rpm(rpms, rpm_pattern)
    if rpm:
        rpm_version = rpm.split("-")[hyphen_split]
        return '.'.join(rpm_version.split('.')[0:version_split])
    else:
        return False


def get_puppet_version(puppet_agent_version, puppet_rpm_version):
    error_msg = "Puppet version not found"
    # Only puppet 4+ has puppet-agent rpm
    if puppet_agent_version:
        return puppet_agent_version
    else:
        raise error_msg


def parse_backup_metadata(params):
    with open(params["metadata_path"]) as data_file:
        data = yaml.load(data_file)

    rpm_key = ":rpms" if ":rpms" in data else "rpms"
    rpms = data[rpm_key]
    satellite_version = get_rpm_version(rpms, "^satellite-[\d+].*")
    puppet_agent_version = get_rpm_version(rpms, "^puppet-agent-[\d+].*", 2, 1)
    puppet_rpm_version = get_rpm_version(rpms, "^puppet-[\d+].*", 1, 1)
    puppet_version = get_puppet_version(puppet_agent_version, puppet_rpm_version)

    if not satellite_version or satellite_version not in SUPPORTED_VERSIONS:
        msg = "Satellite version is not supported or found. " \
              "Only Satellite {0} is supported.".format(", ".join(SUPPORTED_VERSIONS))
        return False, dict(msg=msg)

    msg = "{0} backup found".format(satellite_version)
    result = dict(satellite_version=satellite_version,
                  puppet_version=puppet_version,
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
