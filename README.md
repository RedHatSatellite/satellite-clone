# Satellite-clone

Satellite-clone contains simple Ansible playbooks that can be used to perform any of the following tasks:
* Setup a Satellite 6.1 or 6.2 install with restored backup data.
* Change the hostname on an existing Satellite install.

## Getting Started

#### What you need: ####

**to clone a Satellite Server**:

  - A blank (vanilla install) RHEL 7 server. You will run the setup commands here.
  - A backup from a 6.1 or 6.2 Satellite server created with `katello-backup`. This backup can be with or without pulp-data, and can be from a RHEL 6 or 7 machine.
  - You will need a Satellite 6 subscription for the cloned machine. There are [options](https://access.redhat.com/articles/513353) for obtaining subscriptions at a discounted rate for smaller environments. If you would like to handle the registration of the system manually, set `register_to_portal: false` in  `satellite-clone-vars.yml`

**to perform a hostname change**

  - An existing Satellite 6.1 or 6.2 server (can be RHEL 6 or 7). You will run the setup commands here.

#### Setup ####

1. git clone this project.
   ```console
     # git clone https://github.com/RedHatSatellite/satellite-clone.git
   ```

2. Install `ansible` package on the server.  Ansible should be installed from epel.
   ```console
     # yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
     # yum install -y ansible
   ```

Now you can proceed to any of the following tasks:

 * [Cloning a Satellite server](docs/satellite-clone.md)
 * [Changing the hostname of a Satellite server](docs/satellite-hostname.md)

Please check our [FAQ section](docs/faqs.md) for frequently asked questions.
