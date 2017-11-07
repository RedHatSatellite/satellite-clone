#!/usr/bin/env python

import argparse
import os
import subprocess
import sys

def yes_or_no(question):
    while "the answer is invalid":
        reply = str(raw_input(question+' (y/n): ')).lower().strip()
        if reply[0] == 'y':
            return True
        if reply[0] == 'n':
            exit(1)

def main():
    parser = argparse.ArgumentParser(usage="Usage: satellite-clone [options]\n" \
                                           "Example: satellite-clone --start-at-task=\"Clean yum info\"")
    parser.add_argument("-v", "--verbose",
                      action="store_true",
                      dest="verbose",
                      default=False,
                      help="verbose output")
    parser.add_argument("--start-at-task",
                      action="store", # optional because action defaults to "store"
                      dest="start_at_task",
                      help="Start at a specific task",)
    args = parser.parse_args()


    DEFAULT_PRODUCTION_INSTALL_PATH = "/usr/share/satellite-clone"
    DEFAULT_PLAYBOOK_FILE = os.path.join(DEFAULT_PRODUCTION_INSTALL_PATH, "satellite-clone-playbook.yml")

    yes_or_no("This will initiate satellite-clone. Do you want to proceed?")
 
    ansible_args = [] 
    if args.verbose:
        ansible_args.append("-vvv")
    if args.start_at_task:
        ansible_args.append("--start-at-task")
        ansible_args.append(args.start_at_task)

    if not os.path.isdir(DEFAULT_PRODUCTION_INSTALL_PATH):
         sys.stdout.write("It looks like satellite-clone has not been installed properly, " \
                          "{0} does not exist.".format(DEFAULT_PRODUCTION_INSTALL_PATH))
         exit(1)

    os.environ["ANSIBLE_CONFIG"] = os.path.join(DEFAULT_PRODUCTION_INSTALL_PATH, 'ansible.production.cfg')

    inventory_path = os.path.join(DEFAULT_PRODUCTION_INSTALL_PATH, 'inventory')
    ansible_playbook = ["ansible-playbook", "-i", inventory_path] + ansible_args + [DEFAULT_PLAYBOOK_FILE]
 
    sys.stdout.write(" ".join(ansible_playbook))
    run_playbook = subprocess.Popen(ansible_playbook, 
                                    stdout=subprocess.PIPE, 
                                    bufsize=1,
                                    cwd=DEFAULT_PRODUCTION_INSTALL_PATH)

    # provide real-time output
    while True:
        line = run_playbook.stdout.readline()
        sys.stdout.write(line)
        if not line: break
    run_playbook.stdout.close()
    run_playbook.wait()

if __name__ == '__main__':
    main()
