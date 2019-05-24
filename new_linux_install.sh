#!/bin/bash

# Exit script if error encountered
set -e

# .bashrc stuff
echo -e "\n*** Fix .bashrc ***"
echo -e '\n# Custom prompt & aliases' >> .bashrc
echo "PS1='$ '" >> ~/.bashrc
echo "alias ll='ls -lF --group-directories-first'" >> ~/.bashrc
echo "alias ap=ansible-playbook" >> ~/.bashrc
source ~/.bashrc

# APT Stuff
sudo apt-add-repository ppa:ansible/ansible --yes
sudo apt upgrade --yes
sudo apt install ansible git openssh-server jq tree --yes
sudo apt install python-pip python3-pip python-setuptools build-essential python-dev libffi-dev --yes
sudo apt autoremove --yes

# PIP Stuff
pip install httplib2 pysnmp jinja2 six bracket-expansion yamllint

# Fix ansible.cfg
sudo sed -i 's/#gathering.*/gathering = explicit/' /etc/ansible/ansible.cfg
sudo sed -i 's/#host_key_checking.*/host_key_checking = False/' /etc/ansible/ansible.cfg
sudo sed -i 's/#scp_if_ssh.*/scp_if_ssh = True/' /etc/ansible/ansible.cfg
sudo sed -i 's/#retry_files_enabled.*/retry_files_enabled = False/' /etc/ansible/ansible.cfg
sudo sed -i 's/#library.*/library = \/usr\/share\/ansible\/plugins\/modules:$HOME\/.ansible\/plugins\/modules/' /etc/ansible/ansible.cfg

# Install Citrix NITRO SDK
git clone https://github.com/citrix/netscaler-ansible-modules.git
pip install netscaler-ansible-modules/deps/nitro-python-1.0_kamet.tar.gz
sudo python netscaler-ansible-modules/install.py
rm -rf netscaler-ansible-modules

# Install Ansible NAPALM
pip install napalm-ansible
sudo sed -i '/^library/ s/$/:$HOME\/.local\/lib\/python2.7\/site-packages\/napalm_ansible\/modules/' /etc/ansible/ansible.cfg

# Install Ansible NTC
mkdir -p ~/.ansible/plugins/modules/
git clone https://github.com/networktocode/ntc-ansible --recursive ~/.ansible/plugins/modules/ntc_ansible
cd ~/.ansible/plugins/modules/ntc_ansible/ntc-templates/
sudo python setup.py install
cd ~/.ansible/plugins/modules/ntc_ansible/
sudo python setup.py install

# Install Check Point API Python SDK & Ansible modules
pip install git+https://github.com/CheckPointSW/cp_mgmt_api_python_sdk
git clone https://github.com/CheckPointSW/cpAnsible
mkdir ~/.ansible/plugins/modules/check_point_mgmt
cp cpAnsible/check_point_mgmt/check_point_mgmt.py ~/.ansible/plugins/modules/check_point_mgmt
rm -rf cpAnsible

# Run checks!
cd ~
echo -e "\n\nScript execution finished. To verify installations, try running:\n- ansible --version\n- ansible-doc napalm_get_facts\n- ansible-doc ntc_file_copy"
