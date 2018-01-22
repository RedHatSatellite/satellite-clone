## Cloning a Satellite server

#### Important Notes ####

  - The playbook will update the cloned Satellite hostname to match the hostname of the original Satellite from which the backup is generated.
  - On the clone, refreshing the manifest will invalidate the original Satellite's manifest.
  - DHCP, DNS, TFTP, and IPA authentication will be disabled during the install to avoid configuration errors. If you want to use provisioning on the cloned Satellite, you will have to manually re-enable these settings after the playbook run.
  - If you are using Remote Execution, you will have to re-copy the ssh keys to your clients. The keys are regenerate during the install portion of the clone process.
  - The playbook will reset the admin password to "changeme".
  - The playbook run may may take a while to complete.
  - You can clone RHEL 6 backup data to a RHEL 7 machine.  In this case, you must update the variable `rhel_migration` to true as explained later in this document. Please note that this scenario is supported only for *Satellite 6.2*.
  - If you are using NFS for storage and your pulp backup tar file is large (>150 gb), you might see memory errors while untaring pulp data. In this case don't include pulp_data.tar and instead copy over /var/lib/pulp from the source machine to the new machine.
  - Capsules will be unassociated with Lifecycle environments to avoid any interference with existing infrastructure. Instructions to reverse these changes can be found in `logs/reassociate_capsules.txt` under Satellite Clone's root directory
  - It is recommended to clone to an environment that is isolated from your original Satellite's network. We take steps to disable communication from the cloned Satellite to existing capsules and hosts, but the only way to ensure this is in an isolated environment.

#### Prerequisites ####

1. You will need files from a katello-backup (`katello-backup` on the `Satellite server`).
   Required backup files:
   - Standard backup scenario: config_files.tar.gz, mongo_data.tar.gz, pgsql_data.tar.gz, (optional) pulp_data.tar
   - Online backup or RHEL 6 to 7 migration scenario: config_files.tar.gz, mongo_dump folder, foreman.dump, candlepin.dump, (optional) pulp_data.tar

2. Make sure that the blank machine has adequate space compared to the original Satellite server.

#### Instructions ####

1. Create file `satellite-clone-vars.yml` (by copying `satellite-clone-vars.sample.yml` found in the root of the project) and update the required variables.

   ```console
     # cp satellite-clone-vars.sample.yml satellite-clone-vars.yml
   ```
2. Place the backup files in `/backup` folder on the blank machine. If using a different folder, update `backup_dir` variable in `satellite-clone-vars.yml`.
3. If you are cloning RHEL 6 backup data to a RHEL 7 machine, update the variable `rhel_migration` to true in `satellite-clone-vars.yml`.
4. You are required to register and subscribe the blank machine to Red Hat portal to get content for the Satellite installation.  Alternatively, to let the clone tool register to Red Hat portal, you can override `register_to_portal` to `true` and update `activationkey`, `org` variables in `satellite-clone-vars.yml`.
5. It is assumed that you have access to the required repositories for Satellite installation. If using custom repositories for Satellite installation, override `enable_repos` to `false` in `satellite-clone-vars.yml`.
6. Run the ansible playbook from the root directory of this project:

    ```console
      # ansible-playbook satellite-clone-playbook.yml
    ```
