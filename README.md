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

 * [Cloning a Satellite host](docs/cloning.md)
 * [Changing the hostname of a Satellite host](docs/hostname-change.md)
 * [Update Satellite to a new minor version](docs/minor-update.md)
