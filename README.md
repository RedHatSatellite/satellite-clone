# Satellite-clone

Easily setup a Satellite 6.1, 6.2, or 6.3 server with restored backup data.

## Getting Started
Throughout this documentation, ensure that you understand the following terminology:
- Source server: Existing Satellite server.
- Target server: new server, to which Satellite server is being cloned.

#### What you need: ####
  - A blank (vanilla install) RHEL 7 server (target server). You will run the setup commands here.
  - A backup from a 6.1, 6.2, or 6.3 Satellite server (source server) created with `katello-backup`. This backup can be with or without pulp-data, and can be from a RHEL 6 or 7 machine.
  - You will need a Satellite 6 subscription for the cloned machine. With the new Satellite Infrastructure [subscription model](https://access.redhat.com/solutions/3382781) you should have multiple Satellite subscriptions available.

#### Setup ####

On the target server:

1. git clone this project.
   ```console
     # git clone https://github.com/RedHatSatellite/satellite-clone.git
   ```

2. Install `ansible` package.  Ansible should be installed from extras channel.
   ```console
     # subscription-manager repos --enable rhel-7-server-extras-rpms
     # yum install -y ansible
   ```

Now you can proceed to performing the [cloning process](docs/satellite-clone.md). Please check our [FAQ section](docs/faqs.md) for frequently asked questions.

## Development ##

To make a contribution, please fork the repository and open up a pull request with your branch. All pull requests need to have a corresponding issue, you can comment the issue that your are fixing by putting `Fixes #302` (where 302 is the issue number) in the commit message. If there is no issue yet for your problem, just open one up! Community issues and contributions are always appreciated.

Testing is automated and can be run by commenting `yee-haw` on a pull request.

#### Fact caching ####
In order to have the functionality of start-at-task and interactive mode, we cache facts so they can be re-used if someone wants to start the playbook at a certain step. The syntax for this looks something like:
```
- name: Check for config tar file
  stat:
    path: '{{ backup_dir }}/config_files.tar.gz'
    get_checksum: False
    get_md5: False
  register: config_data

- name: set fact - config_data
  set_fact:
    clone_config_data_exists: "{{ config_data.stat.exists }}"
    cacheable: True
```
Any variable-type data should be stored as a fact and made cacheable. Note that `cacheable: True` should be set for every fact.
