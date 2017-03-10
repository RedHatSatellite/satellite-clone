## Cloning a Satellite server

 **Important Notes:**

  - The playbook will update the cloned Satellite hostname to match the hostname of the original Satellite from which the backup is generated.
  - DHCP, DNS, and TFTP will be disabled during the install to avoid configuration errors. If you want to use provisioning on the cloned Satellite, you will have to manually re-enable these settings after the playbook run.
  - The playbook will reset the admin password to "changeme".
  - The playbook run may may take a while to complete.
  - The destination node must have the same OS version as the original Satellite from which the backup data was generated.
    *Note:* You can optionally choose to clone a rhel6 Satellite server to a rhel7 machine.  In this case, you must update the variable `rhel_migration` to true as explained later in this document. Please note that this scenario is supported only for *Satellite 6.2*.
  - If you are using NFS for storage and your pulp backup tar file is large (>150 gb), you might see memory errors while untaring pulp data.  In this case you can optionally choose to skip pulp restore (by setting `include_pulp_data` to `false` in `satellite-clone-vars.yml`)
  - After running the playbook, existing manifests may have to be refreshed

#### Prerequisites

1. You will need files from a katello-backup (`katello-backup` on the `Satellite server`).
   - The playbook will work with or without the pulp_data.tar file from the backup.
   - *Note:* For cloning a rhel6 Satellite server to a rhel7 machine: In addition to katello-backup created files, you also need foreman.dump and candlepin.dump.  You may utilize the included script [satellite-clone/helpers/postgresql_dump.sh)(../helpers/postgresql_dump.sh) if needed.

#### On the Destination node (blank host)

1. Make sure that the Destination node has adequate space and also make sure that the root partition has all the storage space. You may utilize the included script [satellite-clone/helpers/reallocate.sh] (../helpers/reallocate.sh) if needed.

  **Note** The ansible playbook run will fail if the free space in root partition is less than the value specified in `required_root_free_space` variable in `satellite-clone-vars.yml`

2. Place the backup files in a folder on the Destination node. Also remember this folder path, as this needs to be updated in Control node config file (`backup_dir` variable in `satellite-clone-vars.yml`) later.

#### On the Control node:

1. Create file `satellite-clone-vars.yml` (by copying `satellite-clone-vars.sample.yml` found in the root of the project) and update it as necessary.

   ```console
     # cp satellite-clone-vars.sample.yml satellite-clone-vars.yml
   ```
2. Update the folder path of the backup files on the Destination node in `backup_dir` variable in `satellite-clone-vars.yml`.
3. For cloning a rhel6 Satellite server to a rhel7 machine, update the variable `rhel_migration` to true.
4. Add the IP address of the Destination node to the copied inventory file. If executing the playbook on localhost, add `ansible_connection=local` after the IP address.
5. Run the ansible playbook:

    ```console
      # ansible-playbook -i inventory satellite-clone-playbook.yml
    ```
