% SATELLITE-CLONE(1) Version 1.2 | satellite-clone documentation

NAME
====

**satellite-clone** — Setup a Satellite server with restored backup data.

SYNOPSIS
========

| **satellite-clone** \[**-h**|**\-\-help**] \[**-y**|**\-\-assume-yes**]


DESCRIPTION
===========

Easily setup a Satellite server with restored backup data.
Currently satellite backups are supported.

Throughout this documentation, the following terminology is used:

 - Source server: Existing Satellite server.
 - Target server: new server, to which Satellite server is being cloned.

You will need:
--------------

  - A blank (vanilla install) RHEL 8 machine (target server). You will run the setup commands here.
  - A backup from a Satellite server (source server) created with satellite-maintain backup. This backup can be with or without pulp-data
  - You will need a Satellite 6 subscription for the cloned machine. There are options for obtaining subscriptions at a discounted rate for smaller environments.

To perform the clone:
---------------------

Satellite-clone configuration file is in /etc/satellite-clone/satellite-clone-vars.yml.

On the target server:

 - Place the backup files in "/backup" folder. If using a different folder, update "backup_dir" variable in satellite-clone-vars.yml.
 - You are required to register and subscribe the target server to Red Hat portal to get content for the Satellite installation.  Alternatively, to let the clone tool register to Red Hat portal, you can override "register_to_portal" to "true" and update "activationkey", "org" variables in satellite-clone-vars.yml.
 - It is assumed that the target server has access to the required repositories for Satellite installation. If using custom repositories for Satellite installation, override "enable_repos" to "false" in satellite-clone-vars.yml.
 - Run "satellite-clone". This may take a while to complete.

Options
-------

-h, \-\-help

:  show help message and exit

-y, \-\-assume-yes

:  Assume yes for each question

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
