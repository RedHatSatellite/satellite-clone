#!/usr/bin/env ruby
require 'optparse'

DEFAULT_PRODUCTION_INSTALL_PATH = "/usr/share/satellite-clone"
DEFAULT_PLAYBOOK_FILE = DEFAULT_PRODUCTION_INSTALL_PATH + "/" + "satellite-clone-playbook.yml"

@ansible_args = []

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: satellite-clone [options]\n" \
    "Example: satellite-clone --start-at-task=\"Clean yum info\""

  opts.on("--start-at-task [TASK]", 
          "Start at a specific task i.e. --start-at-task=\"run Satellite 6.2 installer\"") do |task|
    @ansible_args << "--start-at-task=\"#{task}\""
  end

  opts.on("-v","--verbose", "verbose output") do |verbose|
    @ansible_args << "-vvv"
  end

  opts.parse!
end

def yesno
  begin
    system("stty raw -echo")
    str = STDIN.getc
  ensure
    system("stty -raw echo")
  end
  if str.chr.downcase == "y"
    return true
  elsif str.chr.downcase == "n"
    return false
  else
    puts "Invalid Character. Try again: [y/n]"
    yesno
  end
end

unless File.exist?(DEFAULT_PRODUCTION_INSTALL_PATH)
  STDOUT.puts "It looks like satellite-clone has not been installed properly, " \
              "#{DEFAULT_PRODUCTION_INSTALL_PATH} does not exist. "
  exit(false)
end

# Set ansible config location as env variable otherwise it may not be noticed
# by ansible
ENV["ANSIBLE_CONFIG"] = "#{DEFAULT_PRODUCTION_INSTALL_PATH}/ansible.production.cfg"

unless IO.readlines("#{DEFAULT_PRODUCTION_INSTALL_PATH}/ansible.cfg")[-1].include?("deprecation_warning")
  open("#{DEFAULT_PRODUCTION_INSTALL_PATH}/ansible.cfg", 'a') do |f|
    f.puts "deprecation_warnings=False"
  end
end

STDOUT.print("This will initiate satellite-clone. Do you want to proceed? [y/n]")
response = yesno
STDOUT.puts "\n" 
exit(false) unless response

inventory_path = "#{DEFAULT_PRODUCTION_INSTALL_PATH}/inventory"
DIR.chdir("#{DEFAULT_PRODUCTION_INSTALL_PATH}") do
  STDOUT.puts "Running #{DEFAULT_PLAYBOOK_FILE}"
  pipe = IO.popen("ansible-playbook -i #{inventory_path} #{@ansible_args.join(" ")} #{DEFAULT_PLAYBOOK_FILE}")
  while (line = pipe.gets)
    print line
  end
end
