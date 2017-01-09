## Cloning a Satellite host

#### Prerequisites

1. You will need files from a katello-backup (`katello-backup` on the `Satellite host`).

*Note:* The cloning playbook will work with or without the pulp_data.tar file from the backup.

#### On the Destination node (blank host)

1. Make sure that the Destination node has adequate space and also make sure that the root partition has all the storage space. You may utilize this [script] (https://gist.githubusercontent.com/sthirugn/cdc34006ae280c344a15a474f7e35918/raw/d6382b8ffabcd9b2a5ab07150201388abfb7e01f/reallocate.sh) if needed.

  **Note** The ansible playbook run will fail if the free space in root partition is less than the value specified in `required_root_free_space` variable in [roles/sat6repro/vars/main.yml] (roles/sat6repro/vars/main.yml)

#### On the Control node

1. Move the data backup tar files - config, pgsql, mongodb to the Control Node  under the project folder - [satellite-clone/roles/sat6repro/files] (roles/sat6repro/files) so Ansible can find them.
2. Create file `roles/sat6repro/vars/main.yml` (by copying `roles/sat6repro/vars/main.sample.yml`) and update it as necessary.

   ```console
     # cp roles/sat6repro/vars/main.sample.yml roles/sat6repro/vars/main.yml
   ```
3. Add the IP address of the Destination node to the copied inventory file. If executing the playbook on localhost, add `ansible_connection=local` after the IP address.

4. Run the ansible playbook:

    ```console
      # ansible-playbook -i inventory satellite-clone-playbook.yml
    ```
  **Note:**

  1. The playbook installs Satellite and may may take a while to complete.
  2. To view the sequence of steps performed by this playbook see the [readme] (roles/sat6repro/README.md#sequence-of-steps-performed-by-this-playbook) section of the sat6repro role.
  3. The playbook will reset the admin password to "changeme"
  4. The installer will be run with `--foreman-proxy-dns false --foreman-proxy-dhcp false` to avoid configuration errors during the install. If you want to use provisioning on the cloned Satellite, you will have to manually re-enable these settings.


