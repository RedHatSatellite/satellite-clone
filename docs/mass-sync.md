## Cloning a Satellite host

This playbook will trigger a sync for all repos on your Satellite. This is a helpful playbook to run after cloning without a pulp_data.tar file, which will leave you with unsynced repos.

#### On the Control node

1. Update `roles/mass_repo_resync/vars/main.yml` with your Satellite admin username and password.
2. Run `ansible-playbook -i inventory satelite-mass-sync-playbook.yml`
