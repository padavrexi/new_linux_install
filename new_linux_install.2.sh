#!/bin/bash
# Exit script if error encounteredd
set -e
#
# Install Citrix NITRO SDK
git clone https://github.com/citrix/netscaler-ansible-modules.git
pip install netscaler-ansible-modules/deps/nitro-python-1.0_kamet.tar.gz --user
sudo python netscaler-ansible-modules/install.py
rm -rf netscaler-ansible-modules
#
# Install Ansible NAPALM
pip install napalm-ansible --user
sudo sed -i '/^library/ s/$/:$HOME\/.local\/lib\/python2.7\/site-packages\/napalm_ansible\/modules/' /etc/ansible/ansible.cfg
#
# Install Ansible NTC
mkdir -p ~/.ansible/plugins/modules/
git clone https://github.com/networktocode/ntc-ansible --recursive ~/.ansible/plugins/modules/ntc_ansible
cd ~/.ansible/plugins/modules/ntc_ansible/ntc-templates/
sudo python setup.py install
cd ~/.ansible/plugins/modules/ntc_ansible/
sudo python setup.py install
#
# Install Check Point API Python SDK & Ansible modules
pip install git+https://github.com/CheckPointSW/cp_mgmt_api_python_sdk --user
git clone https://github.com/CheckPointSW/cpAnsible
mkdir ~/.ansible/plugins/modules/check_point_mgmt
cp cpAnsible/check_point_mgmt/check_point_mgmt.py ~/.ansible/plugins/modules/check_point_mgmt
rm -rf cpAnsible
#
# Run checks!
cd ~
echo -e "\n\nScript execution finished. To verify installations, try running:\n- ansible --version\n"
