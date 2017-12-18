% SATELLITE-CLONE(1) Version 1.2 | satellite-clone documentation

NAME
====

**satellite-clone** — Setup a Satellite 6.1 or 6.2 install with restored backup data.

SYNOPSIS
========

| **satellite-clone** \[**-h**|**--help**] \[**-v**|**--verbose**] \[**--start-at-task TASK**] \[**--step**]

DESCRIPTION
===========

Restores a working Satellite 6 instance from a backup.
Currently satellite 6.1 and 6.2 backups are supported.

You will need:
--------------

  - A blank, clean install, RHEL 7 machine,
  - A Satellite backup (katello-backup in 6.1 and 6.2), see the required files below
    - Standard backup scenario: config_files.tar.gz, mongo_data.tar.gz, pgsql_data.tar.gz, (optional) pulp_data.tar
    - Online backup or RHEL 6 to 7 migration scenario: config_files.tar.gz, mongo_dump folder, foreman.dump, candlepin.dump, (optional) pulp_data.tar

To perform the clone:
---------------------

  - Place the backup files in a folder on the blank machine. This folder path is specified in the "backup_dir" variable in /etc/satellite-clone/satellite-clone-vars.yml and can be changed.
  - If you are cloning RHEL 6 backup data to a RHEL 7 machine, update the variable "rhel_migration" (Satellite 6.2 only) to true in satellite-clone-vars.yml.
  - In the same file either add an activation key from the Red Hat portal OR setup the proper Satellite subscriptions yourself and change "register_to_portal" to false in satellite-clone-vars.yml
  - Run satellite-clone


Options
-------

-v, --verbose

:  Verbose output

--start-at-task TASK

:  Start at a specific task. It's best to start at a task that has been previously run to avoid errors. i.e. --start-at-task="run Satellite 6.2 installer"

--step

:  Interactive, confirm each task before running

--list-tasks

:  List tasks that will run in the satellite-clone playbook

--flush-cache

:  Clear the fact cache

FILES
=====

*/etc/satellite-clone/satellite-clone-vars.yml*

:   satellite-clone configuration file

BUGS
====

Please file bugs in Red Hat Bugzilla <https://bugzilla.redhat.com/> using product "Red Hat Satellite 6" and component "Satellite Clone"

SOURCE
======

<https://github.com/RedHatSatellite/satellite-clone>

COPYRIGHT
=========

Satellite Clone is licensed under GNU General Public License v3.0

AUTHORS
=======

- John Mitsch
- Sureshkumar Thirugnanasambandan
