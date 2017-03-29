#!/bin/bash
# Script to create backup files for RHEL6 to 7 migration.
#
# Notes:
# 1. This script runs katello-backup and also creates foreman.dump and candlepin.dump files from your Satellite6 server.
# 2. Run this script as root user in Satellite6 server.
# 3. This script stops the katello-service in Satellite.  Please plan accordingly for the outage.

set -x

# Create backup folder
export backup_dir="/backup"
mkdir $backup_dir

# Run katello-backup
katello-backup $backup_dir

# Create foreman and candlepin dumps
katello-service stop
service postgresql start
# Open up write access to let postgres user create dump files
chmod o+w $backup_dir
runuser - postgres -c "pg_dump -Fc foreman > "$backup_dir"/foreman.dump"
runuser - postgres -c "pg_dump -Fc candlepin > "$backup_dir"/candlepin.dump"
chmod o-w $backup_dir
katello-service start

set +x

echo "Now, copy the generated files to the destination host:"
echo "config_files.tar.gz, mongo_data.tar.gz, pulp_data.tar,"\
     "candlepin.dump, foreman.dump"
echo "Note: Do not copy the generated pg_sql_data.tar.gz as this is not"\
     "required for RHEL6 to 7 migration process."
