% SATELLITE-CLONE(1) Version 1.2 | satellite-clone documentation

NAME
====

**satellite-clone** — Setup a Satellite 6.1 or 6.2 server with restored backup data.

SYNOPSIS
========

| **satellite-clone** \[**-h**|**--help**] \[**--start-at-task TASK**] \[**--step**] \[**--list-tasks**] \[**--flush-cache**]


DESCRIPTION
===========

Easily setup a Satellite 6.1 or 6.2 server with restored backup data.
Currently satellite 6.1 and 6.2 backups are supported.

Throughout this documentation, the following terminology is used:

 - Source server: Existing Satellite server.
 - Target server: new server, to which Satellite server is being cloned.

You will need:
--------------

  - A blank (vanilla install) RHEL 7 server (target server). You will run the setup commands here.
  - A backup from a 6.1 or 6.2 Satellite server (source server) created with katello-backup. This backup can be with or without pulp-data, and can be from a RHEL 6 or 7 machine.
  - You will need a Satellite 6 subscription for the cloned machine. There are options for obtaining subscriptions at a discounted rate for smaller environments.

To perform the clone:
---------------------

Satellite-clone configuration file is in /etc/satellite-clone/satellite-clone-vars.yml.

On the target server:

 - Place the backup files in "/backup" folder. If using a different folder, update "backup_dir" variable in satellite-clone-vars.yml.
 - If you are cloning RHEL 6 backup data to a RHEL 7 machine, update the variable "rhel_migration" to "true" in satellite-clone-vars.yml.
 - You are required to register and subscribe the target server to Red Hat portal to get content for the Satellite installation.  Alternatively, to let the clone tool register to Red Hat portal, you can override "register_to_portal" to "true" and update "activationkey", "org" variables in satellite-clone-vars.yml.
 - It is assumed that the target server has access to the required repositories for Satellite installation. If using custom repositories for Satellite installation, override "enable_repos" to "false" in satellite-clone-vars.yml.
 - Run "satellite-clone". This may take a while to complete.

Options
-------

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
