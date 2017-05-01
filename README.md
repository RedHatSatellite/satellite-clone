# Satellite-clone

Satellite-clone contains simple Ansible playbooks that can be used to perform any of the following tasks:
* Setup a Satellite 6.1 or 6.2 install with restored backup data.

## Getting Started

#### What you need: ####

**to clone a Satellite Server**:

  - A blank (vanilla install) RHEL 7 server. You will run the setup commands here.
  - A backup from a 6.1 or 6.2 Satellite server created with `katello-backup`. This backup can be with or without pulp-data, and can be from a RHEL 6 or 7 machine.

#### Setup ####

1. yum install satellite-clone
   ```console
    yum install -y satellite-clone
   ```

2. Install `ansible` package on the server.  Ansible should be installed from epel.
   ```console
     # yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
     # yum install -y ansible
   ```

Now you can proceed to any of the following tasks:

 * [Cloning a Satellite server](docs/satellite-clone.md)
