#!/usr/bin/env ruby
require 'optparse'
require_relative 'lib/packaging_helpers'

DEFAULT_PLAYBOOK_FILE = "satellite-clone-playbook.yml"
DEFAULT_PRODUCTION_INSTALL_PATH = "/usr/share/satellite-clone"

@options = {}
@options[:development] = false
@options[:playbook] = DEFAULT_PLAYBOOK_FILE

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: satellite-clone [options]\n" \
    "Example: satellite-clone --development"

  opts.on("--playbook [PLAYBOOK]", String, "location of your satellite-clone playbook, defaults to #{DEFAULT_PLAYBOOK_FILE}") do |playbook|
    @options[:playbook] = playbook
  end

  opts.on("--development", "run in development mode") do |development|
    @options[:development] = true
  end

  opts.parse!
end

unless File.exist?(@options[:playbook])
  STDOUT.puts "#{@options[:playbook]} does not exist, please specify an existing file path for --playbook"
  exit(false)
end

unless @options[:development] 
  unless File.exist?(DEFAULT_PRODUCTION_INSTALL_PATH)
    STDOUT.puts "It looks like satellite-clone has not been installed properly, " \
                "#{DEFAULT_PRODUCTION_INSTALL_PATH} does not exist. " \
                "If you are trying to run in development mode, use --development"
    exit(false)
  end
end

STDOUT.print("This will initiate a satellite-clone playbook using #{@options[:playbook]}. Do you want to proceed? [y/n]")
response = PackagingHelpers.yesno
STDOUT.puts "\n" 
exit(false) unless response

`cd #{DEFAULT_PRODUCTION_INSTALL_PATH}` unless @options[:development]
`ansible-playbook #{@options[:playbook]}`
