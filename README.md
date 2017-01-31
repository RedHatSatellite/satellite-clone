# Satellite-clone
Satellite-clone contains simple Ansible playbooks that can be used to perform any of the following tasks:
* Setup Satellite 6.1 or 6.2 install with the Satellite backup data.
* Change the hostname on an existing Satellite install.
* Perform a minor upgrade of an existing Satellite.

## Getting Started
Ideally, you need two hosts to run this project:

1. Ansible Control node (referred to as `Control node` in the rest of this document) is the host from which this ansible project is run.
2. Destination node - This must be one of the following:
    - A blank machine - to clone an existing Satellite Server.
    - A Satellite server - for a hostname change or for Updating Satellite.

**Note**

1. You can get away with using one host by optionally choosing to use the `Destination node` as the `Control node`.
2. Make sure that the `Control node` can connect to the `Destination node` via paswordless ssh.

#### On the Control node:

*Supported versions*
- RHEL 6
- RHEL 7

1. git clone this project.

   ```console
     # git clone https://github.com/RedHatSatellite/satellite-clone.git
   ```
   NOTE: Optionally you may utilize the script [control_node_setup.sh] (helpers/control_node_setup.sh) to perform step 2 below.  The instructions to use this script are documented in the script itself.
2. Install `ansible` package on the Control node. For RHEL boxes, [access to EPEL] (https://access.redhat.com/solutions/3358) is required.

   ```console
     # yum install -y ansible
   ```
3. Create an inventory file named `inventory` (by copying `inventory.sample`) and update it as necessary:

  ```console
    # cp inventory.sample inventory
  ```

Now you can proceed to any of the following tasks:

 * [Cloning a Satellite server](docs/cloning.md)
 * [Changing the hostname of a Satellite server](docs/hostname-change.md)
 * [Update Satellite to a new minor version](docs/minor-update.md)
