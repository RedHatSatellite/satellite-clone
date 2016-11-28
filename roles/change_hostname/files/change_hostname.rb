#!/usr/bin/ruby

# BEFORE RUNNING THIS SCRIPT
#
# Log into UI, rename the default capsule under infrastructure->capsules to the new hostname in both the name and url fields
#
#
require "socket"

STDOUT.puts "Starting the script run..."

NEW_HOSTNAME = ARGV[0]

# Get the hostname from your system
OLD_HOSTNAME = Socket.gethostname

# Check if the default NEW_HOSTNAME variable is updated in vars/main.yml
if NEW_HOSTNAME == "changeme"
  STDOUT.puts "Please update the script variables with your new hostname"
  exit
end

STDOUT.puts "stopping services"
`katello-service stop`

STDOUT.puts "deleting old certs"
`
rm -rfv /etc/pki/katello{,.bak}
rm -rfv /etc/pki/katello-certs-tools{,.bak}
rm -rfv /etc/candlepin/certs/amqp{,.bak}
rm -rfv /etc/foreman-proxy/*ssl*
rm -rfv /etc/foreman/old-certs
rm -rfv /etc/foreman/*.pem
rm -rfv /var/lib/puppet/ssl
rm -rfv /root/ssl-build
`

STDOUT.puts "updating hostname in /etc/hostname"
`sed -i -e 's/#{OLD_HOSTNAME}/#{NEW_HOSTNAME}/g' /etc/hostname`

STDOUT.puts "updating hostname in /etc/hosts"
`sed -i -e 's/#{OLD_HOSTNAME}/#{NEW_HOSTNAME}/g' /etc/hosts`

STDOUT.puts "setting hostname"
`hostnamectl set-hostname #{NEW_HOSTNAME}`

STDOUT.puts "checking if hostname resolves"
hostname = Socket.gethostname
if hostname != NEW_HOSTNAME
  STDOUT.puts "the new hostname does not resolve, check hostname -f"
  exit
end

STDOUT.puts "updating hostname in /etc/foreman-installer/scenarios.d/satellite-answers.yaml"
`sed -i -e 's/#{OLD_HOSTNAME}/#{NEW_HOSTNAME}/g' /etc/foreman-installer/scenarios.d/satellite-answers.yaml`

STDOUT.puts "re-running the Satellite installer"
`
satellite-installer --scenario satellite -v --certs-regenerate-ca=true --certs-regenerate=true \
  --foreman-foreman-url "https://#{NEW_HOSTNAME}" \
  --foreman-servername #{NEW_HOSTNAME} \
  --capsule-qpid-router-broker-addr  #{NEW_HOSTNAME}\
  --certs-ca-common-name #{NEW_HOSTNAME} \
  --certs-node-fqdn #{NEW_HOSTNAME} \
  --capsule-parent-fqdn #{NEW_HOSTNAME}\
  --foreman-proxy-register-in-foreman true
`

STDOUT.puts "Restarting services"
`katello-service restart`

STDOUT.puts "
Hostname change complete!

If you have a capsule you will need to reregister it with RHSM and then run the following (replacing <capsule-hostname> with your capsule's hostname):
capsule-certs-generate --capsule-fqdn '<capsule-hostname>' --certs-tar '~/<capsule-hostname>-certs.tar'

Then follow the output generated by the capsule-certs-generate command
"

STDOUT.puts "Script ends"
