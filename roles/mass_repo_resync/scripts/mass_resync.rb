#!/usr/bin/ruby
username = ARGV[0]
password = ARGV[1]
orgs = `hammer -p changeme --csv organization list | tail -n+2 | awk -F, {'print $1'}`
orgs.split("\n").each do |org|
  `hammer -p changeme --csv repository list --organization-id #{org} | grep -vi '^ID' | awk -F, {'print $1'}`.split("\n").each do |repo|
    `hammer -p changeme repository synchronize --id #{repo} --organization-id #{org} --async`
  end
end
