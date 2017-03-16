## Update Satellite to a new minor version
#### **NOTE: THIS SHOULD ONLY BE USED FOR SATELLITE 6.2.X VERSIONS**
1. Run the ansible playbook:

   Reboot is disabled by default, so to update without a reboot:

   ```console
     # ansible-playbook -i inventory satellite-update-playbook.yml"
   ```

   To update with a reboot:

   ```console
     # ansible-playbook -i inventory satellite-update-playbook.yml --extra-vars "reboot=yes"
   ```
