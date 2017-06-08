#!/bin/sh
#
# Script to run the ansible automation outside of vagrant

# lock down ssh key files, otherwise ansible will bark
find .vagrant/machines -name private_key -exec chmod 0600 {} \;

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true
export ANSIBLE_HOST_KEY_CHECKING=false
export ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes'
# also export below if you cant the remote commands to remain on targt machine in /tmp
#export ANSIBLE_KEEP_REMOTE_FILES=1

ansible-playbook --become \
                 $* \
                 site.yml
