## Cloning a Satellite host

 **Important Notes:**

  - DHCP, DNS, and TFTP will be disabled during the install to avoid configuration errors. If you want to use provisioning on the cloned Satellite, you will have to manually re-enable these settings.
  - The playbook will reset the admin password to "changeme".
  - The playbook installs Satellite and may may take a while to complete.
  - Make sure that the destination node has the same OS version as the original Satellite from which the backup data was generated.

#### Prerequisites

1. You will need files from a katello-backup (`katello-backup` on the `Satellite host`).

*Note:* The cloning playbook will work with or without the pulp_data.tar file from the backup.

#### On the Destination node (blank host)

1. Make sure that the Destination node has adequate space and also make sure that the root partition has all the storage space. You may utilize this [script] (https://gist.githubusercontent.com/sthirugn/cdc34006ae280c344a15a474f7e35918/raw/d6382b8ffabcd9b2a5ab07150201388abfb7e01f/reallocate.sh) if needed.

  **Note** The ansible playbook run will fail if the free space in root partition is less than the value specified in `required_root_free_space` variable in `roles/sat6repro/vars/main.yml`

2. Place the backup files in a folder on the Destination node. Also remember this folder path, as this needs to be updated in Control node config file (`backup_dir` variable in `roles/sat6repro/vars/main.yml`) later.

#### On the Control node:

1. Create file `roles/sat6repro/vars/main.yml` (by copying `roles/sat6repro/vars/main.sample.yml`) and update it as necessary.

   ```console
     # cp roles/sat6repro/vars/main.sample.yml roles/sat6repro/vars/main.yml
   ```
2. Update the folder path of the backup files on the Destination node in `backup_dir` variable in `roles/sat6repro/vars/main.yml`.
3. Add the IP address of the Destination node to the copied inventory file. If executing the playbook on localhost, add `ansible_connection=local` after the IP address.
4. Run the ansible playbook:

    ```console
      # ansible-playbook -i inventory satellite-clone-playbook.yml
    ```
