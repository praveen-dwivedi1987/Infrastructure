#!/bin/bash
sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
systemctl restart sshd
service sshd restart
#TODO: replace bob with your desired username
useradd bob
# TODO: replace password123 with desired password and change bob to your username chosen in useradd 
echo "Password" | passwd --stdin ec2-user