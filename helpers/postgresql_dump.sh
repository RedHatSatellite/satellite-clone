#!/bin/bash
# Notes:
# 1. Use this script to create postgresql dumps - foreman.dump and candlepin.dump from the Satellite server.
# 2. This scripts stops the katello-service in Satellite.  Please plan accordingly for the outage.
export backup_dir="/backup"
mkdir $backup_dir
katello-backup $backup_dir
katello-service stop
service postgresql start
runuser - postgres -c "pg_dump -Fc foreman > $backup_dir/foreman.dump"
runuser - postgres -c "pg_dump -Fc candlepin > $backup_dir/candlepin.dump"
katello-service start
