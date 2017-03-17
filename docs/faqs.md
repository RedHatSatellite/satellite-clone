# FAQs #

## Cloning questions ##
*about satellite-clone-playbook.yml*

#### Can I run Satellite Clone from a different machine? ####

There are many options for where you can run Satellite Clone from, but we specify and test a simple "one machine" installation. RHEL 7 machines are supported as that is what we test on, but Satellite Clone can run on any machine that has ansible installed and can communicate with your blank target machine you are cloning to. Here are some scenarios:

1. Use the blank target machine as the Ansible Control node. This is the "one machine" approach. You can clone the satellite-clone repo on this server, move the backups to the specified folder on the server, and then run the playbook from the repo. This is the scenario we detail in the docs.

2. Use the Satellite you are cloning as the Ansible Control node. You can clone the satellite-clone repo on the existing Satellite server and use that as the Control Node. The target machine is a blank target machine.

3. Use a separate machine as the Ansible Control Node. This is a machine that is seperate from the blank target machine you are cloning to and the Satellite you are cloning. The backups will have to be copied onto the blank target machine.

We only support and test the 1st scenario (the "one machine" approach detailed in our docs). If you are going to try any of the alternative scenarios, it is at your own risk.

#### Can I clone Capsules? ####

Capsules are not able to be cloned at this time (Feb 2017). This is a planned feature.

## Hostname change questions ##
*about satellite-hostname-playbook.yml*

#### Will my Capsules and/or Satellite clients still work after changing the hostname? ####

Unfortunately, they will not. You will have to re-register both capsules and clients, then re-install the capsules using newly generated certificates (`capsule-certs-generate`)
