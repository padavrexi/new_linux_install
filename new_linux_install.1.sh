#!/bin/bash
# Exit script if error encounteredd
set -e
#
# .bashrc stuff
echo -e "\n*** Fix .bashrc ***"
echo -e '\n# Custom prompt & aliases' >> .bashrc
echo "PS1='$ '" >> ~/.bashrc
echo "alias ll='ls -lF --group-directories-first'" >> ~/.bashrc
echo "alias ap=ansible-playbook" >> ~/.bashrc
source ~/.bashrc
#
# APT Stuff
sudo apt-add-repository ppa:ansible/ansible --yes
sudo apt upgrade --yes
sudo apt install ansible git openssh-server jq tree --yes
sudo apt install python-pip python3-pip python-setuptools build-essential python-dev libffi-dev --yes
sudo apt autoremove --yes
#
# PIP Stuff
pip install httplib2 pysnmp jinja2 six bracket-expansion yamllint packaging msrestazure ansible[azure] --user
#
# Fix ansible.cfg
sudo sed -i 's/#gathering.*/gathering = explicit/' /etc/ansible/ansible.cfg
sudo sed -i 's/#host_key_checking.*/host_key_checking = False/' /etc/ansible/ansible.cfg
sudo sed -i 's/#scp_if_ssh.*/scp_if_ssh = True/' /etc/ansible/ansible.cfg
sudo sed -i 's/#retry_files_enabled.*/retry_files_enabled = False/' /etc/ansible/ansible.cfg
sudo sed -i 's/#library.*/library = \/usr\/share\/ansible\/plugins\/modules:$HOME\/.ansible\/plugins\/modules/' /etc/ansible/ansible.cfg
#
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
#
exit
