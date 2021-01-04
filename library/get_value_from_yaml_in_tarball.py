import yaml
import tarfile
from ansible.module_utils.basic import *
from functools import reduce
import operator

DOCUMENTATION = '''
---
module: get_value_from_yaml_in_tarball
description:
    - Return value from a YAML file that is in a tarball
options:
    tarball:
        description:
          - path to tarball that contains the target yaml file.
        required: true
    target_file:
        description:
          - Path of target YAML file
        required: true
    keys:
        description:
          - List of key(s) to find value in file. It can take multiple values for nested keys.
            For example: ["foreman_proxy", "dhcp"] or ["satellite_version"]
        required: true
    allow_null:
        description:
        - Allows the parameter to be null, defaulting to an empty string. Defaults to false.
        required: false
'''

EXAMPLES = '''
- name: Get puppet user from Satellite answers
  get_value_from_yaml_in_tarball:
    tarball: "/path/to/config_files.tar.gz"
    target_file: "etc/foreman-installer/scenarios.d/satellite-answers.yaml"
    keys: ["puppet", "user"]
  register: puppet_user

  then you can use puppet_user.value
'''

BACKUP_CONFIG = "config_files.tar.gz"


# Takes keys in the format ['foo', 'bar']
# when the dict looks like
# { "foo": { "bar": "hi" }}
# will return None if it a key doesn't exist
def get_value(data, keys):
    try:
        return reduce(operator.getitem, keys, data)
    except KeyError:
        return None


def get_value_from_tarball(params):
    config_tar = tarfile.open(params["tarball"])
    answers_file = config_tar.extractfile(params["target_file"])
    allow_null = params.get("allow_null", False)
    answers = yaml.load(answers_file.read())
    found_value = get_value(answers, params['keys'])
    # The value itself can be false, so only check for NoneType
    if found_value is not None:
        return True, dict(msg="Value found!", changed=False, value=found_value)
    elif allow_null:
        return True, dict(msg="Defaulting to \"\"", changed=False, value="")
    else:
        msg = "Keys {} were not found in {}!".format(
            params["keys"], params["target_file"])
        return False, dict(msg=msg)


def main():
    fields = {
        "tarball": {"required": True, "type": "str"},
        "target_file": {"required": True, "type": "str"},
        "keys": {"required": True, "type": "list"},
        "allow_null": {"required": False, "type": "bool", "default": False}
    }
    module = AnsibleModule(argument_spec=fields)
    success, result = get_value_from_tarball(module.params)
    if success:
        module.exit_json(**result)
    else:
        module.fail_json(**result)


if __name__ == '__main__':
    main()
