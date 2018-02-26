#!/usr/bin/ruby
username = "admin"
password = "changeme"
external_capsules = []
external_capsule_ids = `hammer -u #{username} -p #{password} --csv capsule list --search 'feature = \"Pulp Node\"' | grep -v "Warning:" | tail -n+2 | awk -F, {'print $1'}`
if external_capsule_ids.empty?
  STDOUT.puts "There are no external capsules to disassociate."
else
  external_capsule_ids.split("\n").each do |id|
    lifecycle_environment = `hammer -u #{username} -p #{password} --csv capsule content lifecycle-environments --id #{id} | tail -n+2 | awk -F, {'print $2'}`.split("\n")
    name = `hammer -u #{username} -p #{password} --csv capsule info --id #{id} | tail -n+2 | awk -F, {'print $2'}`.chomp
    organization = `hammer -u #{username} -p #{password} --csv capsule info --id #{id}| tail -n+2 | awk -F, '{print $(NF-2)}'`.chomp
    external_capsules << {:id => id, :name => name, :lifecycle_environments => lifecycle_environment, :organization => organization}
  end


  reverse_commands = []
  external_capsules.each do |capsule|
    capsule[:lifecycle_environments].each do |env|
      `hammer -u #{username} -p #{password} --csv capsule content remove-lifecycle-environment --id #{capsule[:id]} --environment #{env} --organization "#{capsule[:organization]}"`
      reverse_command = "hammer -u #{username} -p #{password} --csv capsule content add-lifecycle-environment --id #{capsule[:id]} --environment #{env} --organization \"#{capsule[:organization]}\""
      reverse_commands << reverse_command
    end
  end

  STDOUT.puts "All Capsules are unassociated with any lifecycle environments. This is to avoid any syncing errors with your original Satellite " \
              "and any interference with existing infrastructure. To reverse these changes, run the following commands," \
              " making sure to replace the credentials with your own."
  reverse_commands.each do |reverse|
    STDOUT.puts reverse
  end
end
