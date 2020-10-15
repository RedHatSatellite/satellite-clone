# Cloning a Satellite server #

* [Important Notes](#important-notes)
  - [Before Cloning](#before-cloning)
  - [During Cloning](#during-cloning)
  - [After Cloning](#after-cloning)
  - [RHEL6 to RHEL7 Migration](#rhel6-to-rhel7-migration)
  - [Cloning Without Pulp Data](#cloning-without-pulp-data)
  - [Typical Production Workflow](#typical-production-workflow)
* [Prerequisites](#prerequisites)
* [Instructions](#instructions)

## Important Notes ##
### Before Cloning ###
  - It is recommended that the target server is network isolated. We take steps to disable communication from the target server to existing capsules and hosts, but the only way to ensure this is in an isolated environment.
  - You can choose to perform a clone without a pulp_data.tar file. After the clone run *without pulp content*, you have two options:
    - To recover pulp content after the cloning process, follow these [steps](#cloning-without-pulp-data).
    - If you are cloning just for testing purposes, you can get away with not using pulp data at all. The target server should still be functional other than the pulp content.
  - If your storage is slow (like NFS) and your pulp backup tar file is large (>100 gb), you might see memory errors while untaring pulp data during the playbook run. In this case, don't include pulp_data.tar during the cloning process.

### During Cloning ###
  - The playbook will update the target server's hostname to match the hostname of the source server.
  - The target server will have the same Y version of the source server. For example, if your source server is Satellite version 6.2, your target server will have version 6.2 as well.
  - The playbook will reset the admin password of the target server to "changeme".

### After Cloning ###
  - On the target server, refreshing the manifest will invalidate the source server's manifest.
  - DHCP, DNS, TFTP, and IPA authentication will be disabled during the install to avoid configuration errors. If you want to use provisioning on the target server, you will have to manually re-enable these settings after the playbook run.
  - If you are using Remote Execution, you will have to re-copy the ssh keys to your clients. The keys are regenerate during the install portion of the clone process.
  - On the target server, the capsules will be unassociated with Lifecycle environments to avoid any interference with existing infrastructure. Instructions to reverse these changes can be found in `logs/reassociate_capsules.txt` under Satellite Clone's root directory

### RHEL6 to RHEL7 Migration ###
  - You can clone RHEL 6 backup data to a RHEL 7 machine.  In this case, you must update the variable `rhel_migration` to `true` as explained later in this document.
  - The migration scenario is supported only for *Satellite 6.2*. If you have a RHEL6 Satellite 6.1 server and want to migrate to RHEL7, then perform the following steps:
    - Upgrade RHEL6 Satellite 6.1 to RHEL6 Satellite 6.2.latest using the normal upgrade process.
    - Use this clone tool (also shipped with Satellite 6.2) to migrate from RHEL6 Satellite 6.2.latest to RHEL 7 Satellite 6.2.latest.
    - Upgrade RHEL7 Satellite 6.2.latest to RHEL7 Satellite 6.3.latest using the foreman-maintain (also shipped with Satellite 6.3) tool.

### Cloning Without Pulp Data ###
Note: This step is not required if you used pulp_data.tar during cloning process.
- Use clone tool to clone/migrate from source server to the target server.
- Stop katello-service on the target server: `katello-service stop`
- Copy `/var/lib/pulp` from source server to the target server.
  On the source server:

  ```console
    # rsync -aPz /var/lib/pulp/ target_server:/var/lib/pulp/
  ```
  Note:
  1. This command may take a while to complete in case of large data.
  2. If you find issues in Satellite content syncing post rsync command, verify the contents of `/var/lib/pulp` on the target server.
- Start katello-service on the target server: `katello-service start`

### Typical Production Workflow ###

This workflow will help transition your environment from a current working Satellite to a new cloned Satellite.
  - Backup the source server.
  - Clone/Migrate the source server (RHEL6 Satellite 6.2.latest) server to the target server (RHEL7 Satellite 6.2.latest).
  - Shut down the source server.
  - Update network configuration on the target server, (e.g., DNS) to match the target server’s IP address with its new host name.
  - Restart goferd in Content hosts and capsules to refresh the connection.
  - Test the new target server.
  - Decommission the source server.

## Prerequisites ##

1. You will need files from a katello-backup (`katello-backup` on the `Satellite server`).
   Required backup files:
   - Standard backup scenario: config_files.tar.gz, mongo_data.tar.gz, pgsql_data.tar.gz, (optional) pulp_data.tar
   - Online backup or RHEL 6 to 7 migration scenario: config_files.tar.gz, mongo_dump folder, foreman.dump, candlepin.dump, (optional) pulp_data.tar
   - For Satellite 6.3+ backups, you will need the metadata.yml file from the backup as well as the other required files.

2. The target server must have capacity to store the backup files, which the source server transfers to the target server, and the backup files when they are restored.

## Instructions ##

On the target server:

1. Create file `satellite-clone-vars.yml` (by copying `satellite-clone-vars.sample.yml` found in the root of the project) and update the required variables.

   ```console
     # cp satellite-clone-vars.sample.yml satellite-clone-vars.yml
   ```
2. Place the backup files in `/backup` folder. If using a different folder, update `backup_dir` variable in `satellite-clone-vars.yml`.
3. If you are cloning RHEL 6 backup data to a RHEL 7 machine, update the variable `rhel_migration` to true in `satellite-clone-vars.yml`.
4. You are required to register and subscribe the blank machine to Red Hat Subscription Management to get content for the Satellite installation.  Alternatively, to let the clone tool register with Red Hat, you can override `register_to_portal` to `true` and update `activationkey`, `org` variables in `satellite-clone-vars.yml`.
5. It is assumed that you have access to the required repositories for Satellite installation. If using custom repositories for Satellite installation, override `enable_repos` to `false` in `satellite-clone-vars.yml`.
6. Run the ansible playbook from the root directory of this project:

    ```console
      # ansible-playbook satellite-clone-playbook.yml
    ```
  The playbook run may may take a while to complete.

## Cloning a Satellite With Remote Databases

Cloning a Satellite with external databases can be done using `installer_additional_options` in satellite-clone's configuration file. This procedure is experimental, proceed at your own risk. Be sure to take security precautions to ensure the production Satellite server and it's databases will not be affected. It is always recommended to set up the cloned Satellite on an network isolated from your production Satellite.

1. The backup used for this procedure must have the correct options to manage remote databases in `/etc/foreman-installer/scenarios.d/satellite-answers.yaml`. Please check that the answer's file configuration matches your setup.
  - You can check with `tar -xOf config_files.tar.gz etc/foreman-installer/scenarios.d/satellite-answers.yaml | grep -E '(manage.db|db.manage)'`:
  ```
    db_manage: false # Foreman's db is external
    db_manage_rake: true
    candlepin_manage_db: false # Candlepin's db is external
    pulp_manage_db: false # Pulp's db is external
  ```
  - Some of these options are currently (at the time of this writing) [missing from the initial setup documentation](https://bugzilla.redhat.com/show_bug.cgi?id=1887846), so they can be set incorrectly even in functional setups. This can interfere with the cloning process.
  - If these values do not match your setup, they can be corrected on the original Satellite and a new backup created.
2. Set up a base RHEL7 server that will become the cloned Satellite.
3. Set up remote databases according to [Satellite documentation](https://access.redhat.com/documentation/en-us/red_hat_satellite/) in the same way that they were set up on your original Satellite. Do not run any installer steps on the target RHEL7 server that will become the clone.
4. The remote databases for the clone will also need to be reached on the same hostname as ones used for the original Satellite. You can use `/etc/hosts` on the target server to associate the original remote database hostnames with the new clone database IP addresses. Make sure they are reachable from the target server.
5. Install satellite-clone on target server according to [instructions](#instructions), but don't run the playbook yet.
6. Change “overwrite_etc_hosts: true” to false in the `satellite-clone-vars.yml` config file.
7. You will need to make sure the backup hostname can resolve to 127.0.0.1 on the target server. You can update /etc/hosts with this hostname before cloning.
8. Proceed to run the clone playbook as specified in the [instructions](#instructions).

