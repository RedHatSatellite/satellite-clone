#!/usr/bin/env python

from optparse import OptionParser
import os
import subprocess

def yes_or_no(question):
    while "the answer is invalid":
        reply = str(raw_input(question+' (y/n): ')).lower().strip()
        if reply[0] == 'y':
            return True
        if reply[0] == 'n':
            exit()

def tail(f, n, offset=0):
  offset_total = str(n+offset)
  stdin,stdout = os.popen2("tail -n "+offset_total+" "+f)
  stdin.close()
  lines = stdout.readlines(); stdout.close()
  return lines[:,-offset]

def main():
    parser = OptionParser(usage="Usage: satellite-clone [options]\n" \
				"Example: satellite-clone --start-at-task=\"Clean yum info\"")
    parser.add_option("-v", "--verbose",
                      action="store_true",
                      dest="verbose",
                      default=False,
                      help="verbose output")
    parser.add_option("--start-at-task",
                      action="store", # optional because action defaults to "store"
                      dest="start_at_task",
                      help="Start at a specific task",)
    parser.add_option("-i", "--interactive",
                      action="store_true",
                      dest="interactive",
                      default=False,
                      help="interactive mode with prompt for each task")
    (options, args) = parser.parse_args()


    DEFAULT_PRODUCTION_INSTALL_PATH = "/usr/share/satellite-clone"
    DEFAULT_PLAYBOOK_FILE = DEFAULT_PRODUCTION_INSTALL_PATH + "/satellite-clone-playbook.yml"

    yes_or_no("This will initiate satellite-clone. Do you want to proceed?")
 
    ansible_args = [] 
    if options.verbose:
        ansible_args.append("-vvv")
    if options.start_at_task:
        ansible_args.append("--start-at-task \"{0}\"".format(options.start_at_task))
    if options.interactive:
        ansible_args.append("--interactive")

    if not os.path.isdir(DEFAULT_PRODUCTION_INSTALL_PATH):
         print("It looks like satellite-clone has not been installed properly, " \
               "{0} does not exist.".format(DEFAULT_PRODUCTION_INSTALL_PATH))
         exit()

    os.environ["ANSIBLE_CONFIG"] = "{0}/ansible.production.cfg".format(DEFAULT_PRODUCTION_INSTALL_PATH)

    inventory_path = "{0}/inventory".format(DEFAULT_PRODUCTION_INSTALL_PATH)
    ansible_playbook = "ansible-playbook -i {0} {1} {2}".format(inventory_path, 
                                                                 " ".join(ansible_args),
                                                                 DEFAULT_PLAYBOOK_FILE)
 
    print(ansible_playbook)
    run_playbook = subprocess.Popen(ansible_playbook, 
                                    shell=True, 
                                    stdout=subprocess.PIPE, 
                                    bufsize=1,
                                    cwd="{0}".format(DEFAULT_PRODUCTION_INSTALL_PATH))

    # provide real-time output
    while True:
        line = run_playbook.stdout.readline()
        print(line)
        if not line: break
    run_playbook.stdout.close()
    run_playbook.wait()

if __name__ == '__main__':
    main()
