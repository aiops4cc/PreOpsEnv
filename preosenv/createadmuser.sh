#!/bin/bash
BaseScriptDir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
source ${BaseScriptDir}/initialosenv.pros
createUser()
{
#Create Admin User for Automation Scripts
 #userName=ocopsadm
 #defaultPWD=zaq12wsx
 /sbin/useradd ${userName}
 echo $defaultPWD | passwd --stdin ${userName}
 id $userName
}
configSSHkey()
{
 su - ${userName}<<EOF
 mkdir ~/.ssh
 chmod 700 .ssh
 cat /var/tmp/preosenv/${userName}_rsa.pub>~/.ssh/authorized_keys
 chmod 600 ~/.ssh/authorized_keys
EOF
}
configsudo4user()
{
 echo "${userName}       ALL=(ALL)       NOPASSWD: ALL">/etc/sudoers.d/ocopsadm
 cat /etc/sudoers.d/ocopsadm
}
#Main Fuction
createUser
configSSHkey
configsudo4user
