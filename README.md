# Satellite-clone
Satellite-clone contains simple Ansible playbooks that can be used to perform any of the following tasks:
* Setup Satellite 6.1 or 6.2 install with the Satellite backup data.
* Change the hostname on an existing Satellite install.

## Getting Started
Ideally, you need two hosts to run this project:

1. Ansible Control node (referred to as `Control node` in the rest of this document) is the host from which this ansible project is run.
2. A `Satellite host` (for hostname change) or a `blank host` (to clone existing Satellite 6.1 or 6.2)

**Note**

1. You can get away with using one host by optionally choosing to use the `Satellite host` as the `Control node`.
2. Make sure that the Control node can connect to the Satellite host via paswordless ssh.

#### On the Control node:

*Supported versions*
- RHEL 6
- RHEL 7

1. Installation of required packages:
   a. Install `ansible` package on the Control node. For RHEL boxes, [access to EPEL] (https://access.redhat.com/solutions/3358) is required.

      ```console
        # yum install -y ansible
      ```
   b. Since the playbook uses `synchronize` module, install `rsync` package on the Ansible Control node.

      ```console
        # yum install -y rsync
      ```
2. git clone this project.

  ```console
     # git clone https://github.com/RedHatSatellite/satellite-clone.git
  ```
3. Create an inventory file named `inventory` (by copying `inventory.sample`) and update it as necessary:

  ```console
    # cp inventory.sample inventory
  ```

Now you can proceed to any of the following tasks:

<!-- Do not change link names as they are linked to from external sites! -->
 * [Cloning a Satellite host](#cloning-a-satellite-host)
 * [Changing the hostname of a Satellite host](#changing-the-hostname-of-a-satellite-host)
 * [Update Satellite to a new minor version](#update-satellite-to-a-new-minor-version)

## Cloning a Satellite host

#### Prerequisites

1. You will need files from a katello-backup (`katello-backup` on the `Satellite host`).

*Note:* The cloning playbook will work with or without the pulp_data.tar file from the backup.

#### On the Destination node (blank host)

1. Make sure that the Destination node has adequate space and also make sure that the root partition has all the storage space. You may utilize this [script] (https://gist.githubusercontent.com/sthirugn/cdc34006ae280c344a15a474f7e35918/raw/d6382b8ffabcd9b2a5ab07150201388abfb7e01f/reallocate.sh) if needed.

  **Note** The ansible playbook run will fail if the free space in root partition is less than the value specified in `required_root_free_space` variable in [roles/sat6repro/vars/main.yml] (roles/sat6repro/vars/main.yml)

#### On the Control node:

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

## Changing the Hostname of a Satellite host
### **NOTE: This script must be used for Satellite 6.2 only**
#### On the Satellite host
1. Before you run the hostname change playbook, you have to make a manual change to the default capsule's hostname. Log into UI and rename the default capsule (under infrastructure->capsules) to the new hostname using both the name and url fields.

#### On the Control node
1. Update the required sections in [roles/change_hostname/vars/main.yml] (roles/change_hostname/vars/main.yml).
2. Update the [inventory] (inventory) file under the root of this project to add your Satellite host's ip address. If executing the playbook on localhost, add `ansible_connection=local` after the IP address
3. Run the ansible playbook:

    ```console
      # ansible-playbook -i inventory satellite-hostname-playbook.yml
    ```
4. If you have a capsule you will need to reregister it with RHSM and then run the following (replacing `<capsule-hostname>` with your capsule's hostname):

   ```console
     # capsule-certs-generate --capsule-fqdn '<capsule-hostname>' --certs-tar '~/<capsule-hostname>-certs.tar'`
   ```
Then follow the output generated by the capsule-certs-generate command

## Other misc Satellite6 tools:

### Update Satellite to a new minor version:
#### **NOTE: THIS SHOULD ONLY BE USED FOR SATELLITE 6.2.X VERSIONS**
1. Update the [inventory] (inventory) file under the root of this project to add your Satellite host's ip address. If executing the playbook on localhost, add `ansible_connection=local` after the IP address
2. Run the ansible playbook:

   Reboot is disabled by default, so to update without a reboot:

   ```console
     # ansible-playbook -i inventory satellite-update-playbook.yml"
   ```

   To update with a reboot:

   ```console
     # ansible-playbook -i inventory satellite-update-playbook.yml --extra-vars "reboot=yes"
   ```
