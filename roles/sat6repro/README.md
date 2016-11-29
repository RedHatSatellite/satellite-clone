sat6repro
=========

Quickly setup Satellite from backup data.

## Sequence of steps performed by this playbook:

1. Optionally, turn off firewall.
2. Update hostname of the blank host to the supplied host name.
3. Register/Subscribe the host to Customer portal using the supplied credentials.
4. Disable all repos and enable only the repos that are required for Satellite
   installation.
5. Install vim. (for easy editing of configs in future)
6. Install packages for Satellite 6.1 or 6.2 based on the provided information.
7. Untar the provided Config backup file.
8. Run katello-installer or satellite-installer based on Satellite versions -
   6.1 or 6.2.
9. Untar pgsql, mongo data tar files. Restart required services.
10. Update the Satellite default password for admin to `changeme`.
11. Fix the katello assets link which point to an invalid path.

Requirements
------------

None

Role Variables
--------------

See vars/main.yml

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      roles:
         - sat6repro

License
-------

BSD

Author Information
------------------

sthirugn at redhat dot com
