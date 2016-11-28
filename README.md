This project can be used to quickly setup Satellite 6.1 or 6.2 install with the backup Satellite data.

## RUN CLONE PLAYBOOK:

### Pre-requisites:

### Satellite VM requirements:

1. Bring your own vm.
2. Make sure that the vm has adequate space and also make sure that the root partition has all the storage space. You may utilize this script:

    ```console
     # curl -O
     https://gist.githubusercontent.com/sthirugn/cdc34006ae280c344a15a474f7e35918/raw/28c33aa6ccf7ce39cad5692d44702b839023941a/reallocate.sh
     # /bin/bash reallocate.sh
    ```
   Note: The ansible playbook run will fail and not proceed if the free space in root partition is less than the value specified in `required_root_free_space` variable in `roles/sat6repro/vars/main.yml`

### Workstation requirements:
3. Install `ansible` package in your workstation. For RHEL boxes, [access to EPEL] (https://access.redhat.com/solutions/3358) is required.

    ```console
     # yum install -y ansible
    ```
4. Make sure that your workstation is able to talk to the Satellite vm using ssh.
5. git clone this project in your workstation.

    ```console
     # git clone git@github.com:RedHatSatellite/satellite-clone.git
    ```
6. Download the data backup tar files - config, pgsql, mongodb in your workstation under the project folder - satellite-clone/roles/sat6repro/files so Ansible can find them.
7. Update the required sections in `roles/sat6repro/vars/main.yml`.
8. Update the `inventory` file under the root of this project to add your Satellite VM's ip address.
9. Run the ansible playbook:

    ```console
      # ansible-playbook -i inventory deploy-clone-playbook.yml
    ```
**Note:** The playbook run installs the Satellite and may may take a while to complete.

## Sequence of steps performed by this playbook:

1. Turn off firewall.
2. Update hostname of the Satellite VM to the supplied host name.
3. Register/Subscribe the host to Customer portal using the supplied credentials.
4. Disable all repos and enable only the repos that are required for Satellite
   installation.
5. Install vim. (for easy editing of configs in future)
6. Install packages for Satellite 6.1 or 6.2 based on the provided information.
7. Untar the provided Config backup file.
8. Run katello-installer or satellite-installer based on Satellite versions -
   6.1 or 6.2.
9. Untar pgsql, mongo data tar files. Restart required services.
10. Update the Satellite default password for admin to `changeme`.
11. Fix the katello assets link which point to an invalid path.


## RUN HOSTNAME CHANGE PLAYBOOK:
1. Update the required sections in `roles/change_hostname/vars/main.yml`.
2. Update the `inventory` file under the root of this project to add your Satellite VM's ip address.
3. Run the ansible playbook:
    ```console
      # ansible-playbook -i inventory deploy-hostname-playbook.yml
    ```
