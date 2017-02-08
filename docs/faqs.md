# FAQs #

##Cloning questions##
*about satellite-clone-playbook.yml*

####Where should I run Satellite Clone from?####

There are many options for where you can run Satellite Clone from (referenced as `Control Node` in the documentation). RHEL 6 and 7 machines are supported as that is what we test on, but it can run on any machine that has ansible installed and can communicate with your blank machine you are cloning to (referenced as `Destination Node` in the documentation). It can even be run on the blank Destination Node itself. Here are some typical scenarios:

1. Use the blank destination node as the Control node. This is the "one machine" approach. You can clone the satellite-clone repo on this server, move the backups to the specified folder on the server, and then run the playbook from the repo.

2. Use the Satellite you are cloning as the Control node. You can clone the satellite-clone repo on the existing Satellite server and use that as the Control Node. The Destination Node is a blank machine.

3. Use a separate machine as the Control Node. This is a machine that is seperate from the blank machine you are cloning to and the Satellite you are cloning. The backups will have to be copied onto the server. The Destination Node is a blank machine.

####Can I clone Capsules?####

Capsules are not able to be cloned at this time (Feb 2017). This is a planned feature.

##Hostname change questions##
*about satellite-hostname-playbook.yml*

####Will my Capsules and/or Satellite clients still work after changing the hostname?####

Unfortunately, they will not. You will have to re-register both capsules and clients, then re-install the capsules using newly generated certificates (`capsule-certs-generate`)
