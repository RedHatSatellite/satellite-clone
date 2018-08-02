# Satellite-clone

Easily setup a Satellite 6.1, 6.2, or 6.3 server with restored backup data.

## 1.2.5 release notes

Fixes capsule disassociating script failing on lifecycle envs with spaces
in name.

## 1.2.2 - 1.2.4 release notes

Mostly bug fixes, satellite 6.3 support was added, including with puppet 4

## 1.2.1 release notes

#### Notable commits

4d6e6de7578009a2e6fe87dffd7dc771234aec09 Remove space calculation check
This was causing issues for users and we removed in favor of documentation.

52c91ffbc36c19620916045b11cde60ec050bfa8 Made portal registration disabled by default.
By default, the server will not be registered to Red Hat Portal - It is the responsibility of the user to provide right repos for satellite installation.

75715b4c0195de71f439e5007b2c90bc944023a3 Remove jmx.conf

ee74df471e5b4f0f5598a589b275d711dcd7bbc7 added --flush-cache

e395b95c6f536bfa688a4b5f399a779dc0f288f1 Add option to not overwrite /etc/hosts

3373ff4426b7d233434488c3b335ba84884573c9 Actually drop mongo database

8735944c5dd38a96e96d697d3f273c0c0b94fe4c Ensure satellite isn't already installed
Prevent satellite-clone from running on a system where satellite is installed. The check is skippable.

be5225d61f1b8f82133745d1203061517435d936 Allow multi-word activation key names

5d94c6ee25eccff05c8f894217aed6245e186d34 disable IPA authentication

## 1.2.0 release notes

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
