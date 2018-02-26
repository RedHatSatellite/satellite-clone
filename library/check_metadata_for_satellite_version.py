import yaml
import re
from ansible.module_utils.basic import *


# module: check_metadata_for_satellite_version
# description:
#    - Return the Satellite version specified in a Satellite backup
# notes:
#    - The Satellite version is determined from the Satellite rpm
#      version using the backup's rpm list from metadata.yml
# options:
#    metadata_path:
#        description:
#          - Full path (including file name) to metadata.yml
#        required: true
def get_satellite_backup_version(params):
    with open(params["metadata_path"]) as data_file:
        data = yaml.load(data_file)

    rpms = data[":rpms"]
    pattern = re.compile("^satellite-[\d+].*")
    satellite = [r for r in rpms if pattern.match(r)][0]
    satellite_version = satellite.split("-")[1]

    found_version = '.'.join(satellite_version.split('.')[0:2])

    if found_version not in ["6.2", "6.3"]:
        return False, dict(msg="Satellite Version is not supported")

    msg = "{0} backup found".format(found_version)
    result = dict(satellite_version=found_version, msg=msg, changed=False)
    return True, result


def main():
    fields = {
        "metadata_path": {"required": True, "type": "str"}
    }

    module = AnsibleModule(argument_spec=fields)
    success, result = get_satellite_backup_version(module.params)
    if success:
        module.exit_json(**result)
    else:
        module.fail_json(**result)


if __name__ == '__main__':
    main()
