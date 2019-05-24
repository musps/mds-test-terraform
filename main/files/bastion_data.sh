#!/bin/bash

echo "${ssh_private_key}" > /home/${ssh_user}/.ssh/id_rsa
chmod 600 /home/${ssh_user}/.ssh/id_rsa
chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add
