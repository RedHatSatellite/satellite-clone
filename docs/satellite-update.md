## Update Satellite to a new minor version
#### **NOTE: THIS SHOULD ONLY BE USED FOR SATELLITE 6.2.X VERSIONS**
1. Update the `inventory` file under the root of this project with your Satellite host's ip address and add `ansible_connection=local` after the IP address
   ```
     192.168.1.12 ansible_connection=local
   ```
2. Run the ansible playbook:

   Reboot is disabled by default, so to update without a reboot:

   ```console
     # ansible-playbook -i inventory satellite-update-playbook.yml"
   ```

   To update with a reboot:

   ```console
     # ansible-playbook -i inventory satellite-update-playbook.yml --extra-vars "reboot=yes"
   ```
