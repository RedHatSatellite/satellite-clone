#!/usr/bin/ruby

require 'shellwords'
require 'rubygems'
require 'json'

@username = "admin"
@password = "changeme"

def prepare_hammer_cmd(command)
  "hammer -u #{@username.shellescape} -p #{@password.shellescape} #{command}"
end

def run_hammer_cmd(command)
  command = prepare_hammer_cmd(command)
  `#{command}`
end

def get_ids_from_hammer(command, search = nil)
  JSON.parse(run_hammer_cmd("--output=json " + command + (search ? " --search '#{search}'" : "")).map do |obj|
    obj["Id"]
  end
end

def capsule_lce_args(action, capsule_id, env)
  "--csv capsule content #{action}-lifecycle-environment --id #{capsule_id} --lifecycle-environment-id #{env}"
end

external_capsule_lifecycle_environments = get_ids_from_hammer("capsule list", search = 'feature = "Pulp Node"').map do |id|
  { capsule_id: id, lifecycle_environments: get_ids_from_hammer("capsule content lifecycle-environments --id #{id}") }
end

reverse_commands = external_capsule_lifecycle_environments.map do |association|
  association[:lifecycle_environments].map do |env|
    run_hammer_cmd(capsule_lcs_args("remove", association[:capsule_id], env))
    prepare_hammer_cmd(capsule_lce_args("add", association[:capsule_id], env))
  end
end.flatten

if reverse_commands.empty?
  STDOUT.puts "There were no associated lifecycle environments to disassociate from external capsules."
else
  STDOUT.puts <<~MESSAGE
    Any external Capsules have been disassociated with any lifecycle environments.
    This is to avoid any syncing errors with your original Satellite and any
    interference with existing infrastructure. To reverse these changes, run the
    following commands, making sure to replace the credentials with your own:

  MESSAGE
  reverse_commands.each { |command| STDOUT.puts command }
end
