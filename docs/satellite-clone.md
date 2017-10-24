## Cloning a Satellite server

#### Important Notes ####

  - The playbook will update the cloned Satellite hostname to match the hostname of the original Satellite from which the backup is generated.
  - DHCP, DNS, TFTP, and remote execution will be disabled during the install to avoid configuration errors. If you want to use provisioning on the cloned Satellite, you will have to manually re-enable these settings after the playbook run.
  - The playbook will reset the admin password to "changeme".
  - The playbook run may may take a while to complete.
  - You can clone RHEL 6 backup data to a RHEL 7 machine.  In this case, you must update the variable `rhel_migration` to true as explained later in this document. Please note that this scenario is supported only for *Satellite 6.2*.
  - If you are using NFS for storage and your pulp backup tar file is large (>150 gb), you might see memory errors while untaring pulp data.  In this case you can optionally choose to skip pulp restore (by setting `include_pulp_data` to `false` in `satellite-clone-vars.yml`).
  - After running the playbook, existing manifests may have to be refreshed.
  - Capsules will be unassociated with Lifecycle environments to avoid any interference with existing infrastructure. Instructions to reverse these changes can be found in `logs/reassociate_capsules.txt` under Satellite Clone's root directory
  - It is recommended to clone to an environment that is isolated from your original Satellite's network. We take steps to disable communication from the cloned Satellite to existing capsules and hosts, but the only way to ensure this is in an isolated environment.

#### Prerequisites ####

1. You will need files from a katello-backup (`katello-backup` on the `Satellite server`).
   Required backup files:
   - Standard backup scenario: config_files.tar.gz, mongo_data.tar.gz, pgsql_data.tar.gz, (optional) pulp_data.tar
   - Online backup or RHEL 6 to 7 migration scenario: config_files.tar.gz, mongo_dump folder, foreman.dump, candlepin.dump, (optional) pulp_data.tar

2. Make sure that the blank machine has adequate space and also make sure that the root partition has all the storage space. You may utilize the included script [satellite-clone/helpers/reallocate.sh](../helpers/reallocate.sh) if needed. The ansible playbook run will fail if the free space in root partition is less than the value specified in `required_root_free_space` variable in `satellite-clone-vars.yml`

#### Instructions ####

1. Create file `satellite-clone-vars.yml` (by copying `satellite-clone-vars.sample.yml` found in the root of the project) and update the required variables.

   ```console
     # cp satellite-clone-vars.sample.yml satellite-clone-vars.yml
   ```
2. Place the backup files in a folder on the blank machine. This folder path is specified in the `backup_dir` variable in `satellite-clone-vars.yml`.
3. Update the folder path of the backup files using the `backup_dir` variable in `satellite-clone-vars.yml`.
4. If you are cloning RHEL 6 backup data to a RHEL 7 machine, update the variable `rhel_migration` to true in `satellite-clone-vars.yml`.
5. Run the ansible playbook from the root directory of this project:

    ```console
      # ansible-playbook satellite-clone-playbook.yml
    ```
