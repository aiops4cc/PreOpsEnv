#!/bin/bash
BaseScriptDir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
source ${BaseScriptDir}/preosenv/initialosenv.pros
createSSHKey()
{
 if [ -f ${BaseScriptDir}/preosenv/${userName}_rsa ]
 then
   echo 
   echo "##############################################################"
   echo "Remove old files and re-generate keypair for ${userName}"
   echo "##############################################################"
   echo
   rm -rf ${BaseScriptDir}/preosenv/${userName}_rsa*
   ssh-keygen -t rsa -N '' -f ${BaseScriptDir}/preosenv/${userName}_rsa
 else
   ssh-keygen -t rsa -N '' -f ${BaseScriptDir}/preosenv/${userName}_rsa
 fi 
}

#Main Fuction
createSSHKey
#Copy script to target host
for targetHost in `echo $hostnameIPlist`
do
   sshpass -p $rootPWD scp -o StrictHostKeyChecking=no -r preosenv ${AdminUser}@${targetHost}:/var/tmp/ 
   sshpass -p $rootPWD ssh  -o StrictHostKeyChecking=no ${AdminUser}@${targetHost} "sudo chmod -R 777 /var/tmp/preosenv/"
   sshpass -p $rootPWD ssh  -o StrictHostKeyChecking=no ${AdminUser}@${targetHost} "sudo /var/tmp/preosenv/createadmuser.sh"
   #sshpass -p ${userPWD}  ssh-copy-id -i ${BaseScriptDir}/preosenv/${userName}_rsa.pub  ${userName}@${targetHost}
done
