# Satellite-clone

Satellite-clone contains simple Ansible playbooks that can be used to setup a Satellite 6.1 or 6.2 install with restored backup data.

## 1.2 release notes

#### Notable commits:

09387bf5bb39dc179c854364f984c41192d307c7 Disable REX on install Fixes #234
Remote execution is disabled on install

fccf47f1928cb01f5e859fca1d62144c94214160 Add option to restorecon the filesystem 
This is useful when fixing permission errors resulting from a bad backup Fixes #220

00155a5fbd2b0b07d2b5224edbbf58e1aea64b5c Fixes pulp duplicate key error Fixes #255 
When cloning w/o pulp_data.tar, the database has to be migrated to recreate indexes and prevent errors like duplicate key errors.

73108b928a965f31889b61d617b96baa4213ecf0 Cleanup paused tasks

ee82d710cf2a241e372ef030e4604f1df3f0fc2e Change disable postgres triggers to true Fixes #257
This setting is now true by default

3cee9fd06f147115ddd865b2ecfe73b6ecd06f7f Updates production cli
adds caching of facts which allows you do do `--start-at-task` and `--step` modes

4c6670eeeac7eb326094f417c84ed8f2612bd438 Migrate cp database after install Fixes #261 - The candlepin database can be restored from an earlier sat version, so we can migrate it before running the upgrade to avoid issues.

aa059b62b0551784de614e6e1489fc82d1d2b5d6 Add man page Fixes #244
can now run `man satellite-clone` to view man pages

f47c96deeb8916e923d2824c22a4a917743faead Add --list-tasks Fixes #265
this is helpful when using `--start-at-task`


## Getting Started

#### What you need: ####

**to clone a Satellite Server**:

  - A blank (vanilla install) RHEL 7 server. You will run the setup commands here.
  - A backup from a 6.1 or 6.2 Satellite server created with `katello-backup`. This backup can be with or without pulp-data, and can be from a RHEL 6 or 7 machine.
  - You will need a Satellite 6 subscription for the cloned machine. There are [options](https://access.redhat.com/articles/513353) for obtaining subscriptions at a discounted rate for smaller environments. If you would like to handle the registration of the system manually, set `register_to_portal: false` in  `satellite-clone-vars.yml`

#### Setup ####

1. git clone this project.
   ```console
     # git clone https://github.com/RedHatSatellite/satellite-clone.git
   ```

2. Install `ansible` package on the server.  Ansible should be installed from extras channel.
   ```console
     # subscription-manager repos --enable rhel-7-server-extras-rpms
     # yum install -y ansible
   ```

Now you can proceed to performing the clone:

 * [Cloning a Satellite server](docs/satellite-clone.md)

Please check our [FAQ section](docs/faqs.md) for frequently asked questions.

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
