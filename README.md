# Satellite-clone

Satellite-clone contains simple Ansible playbooks that can be used to perform any of the following tasks:
* Setup a Satellite 6.1 or 6.2 install with restored backup data.
* Change the hostname on an existing Satellite install.
* Perform a minor upgrade of an existing Satellite. 

## Getting Started

#### What you need: ####

**to clone a Satellite Server**:

    - A blank (vanilla install) RHEL 7 server. You will run the setup commands here.
    - A backup from a 6.1 or 6.2 Satellite server created with `katello-backup`. This backup can be a with or without pulp-data, and can be from a RHEL 6 or 7 machine.

**to perform a hostname change**

    - An existing Satellite 6.1 or 6.2 server (can be RHEL 6 or 7). You will run the setup commands here

#### Setup ####

1. git clone this project.
   ```console
     # git clone https://github.com/RedHatSatellite/satellite-clone.git
   ```
   NOTE: Optionally you may utilize the script [control_node_setup.sh](helpers/control_node_setup.sh) to perform step 2 below.  The instructions to use this script are documented in the script itself.

2. Install `ansible` package on the server. [Access to EPEL](http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F) is required.
   ```console
     # yum install -y ansible
   ```

Now you can proceed to any of the following tasks:

 * [Cloning a Satellite server](docs/satellite-clone.md)
 * [Changing the hostname of a Satellite server](docs/satellite-hostname.md)
 * [Update Satellite to a new minor version](docs/satellite-update.md)

Please check our [FAQ section](docs/faqs.md) for frequently asked questions
