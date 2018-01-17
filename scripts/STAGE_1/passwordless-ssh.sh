#!/bin/bash
#for centos user must first install epel-release, sshpass, and nmap (sshpass and nmap are available from epel-release for CENTOS)

# yum install -y epel-release nmap > /dev/null
# yum install -y sshpass > /dev/null

read -p "Have you installed epel-release, nmap & sshpass? 

Hit enter to continue if so, and are specifying arguments for the script to use...
"

read -p "Enter the username to connect to the remote instances: " USER
echo ""
read -s -p "Enter the password for this user: " PASS
echo ""
read -p "Enter the IP prefix so we can discover all existing nodes (the first three octets will suffice): " IPPRE
HEADNODE=`hostname`
GROUP=$USER

mkdir -p .ssh
echo -e  'y\n' | ssh-keygen -f .ssh/id_rsa -t rsa -N ''

echo 'Host *' >> .ssh/config
echo 'StrictHostKeyChecking no' >> .ssh/config
chmod 400 .ssh/config
chown $USER:$GROUP /home/$USER/.ssh/config

nmap -sn $IPPRE.* | grep $IPPRE. | awk '{print $5}' > nodeips.txt
for NAME in `cat nodeips.txt`; do sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME 'hostname' >> nodenames.txt;done

NAMES=`cat nodenames.txt` #names from names.txt file
for NAME in $NAMES; do
        sshpass -p $PASS scp -o "StrictHostKeyChecking no" -o ConnectTimeout=2 /home/$USER/nodenames.txt $USER@$NAME:/home/$USER/
        sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME "mkdir .ssh && chmod 700 .ssh"
        sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME "echo -e  'y\n' | ssh-keygen -f .ssh/id_rsa -t rsa -N ''"
        sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME 'touch /home/'$USER'/.ssh/config'
        sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME 'echo "Host *" >  /home/'$USER'/.ssh/config'
        sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME 'echo StrictHostKeyChecking no >> /home/'$USER'/.ssh/config'
        sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME 'chmod 400 /home/'$USER'/.ssh/config'
        cat .ssh/id_rsa.pub | sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME 'cat >> .ssh/authorized_keys'
        sshpass -p $PASS scp -o "StrictHostKeyChecking no" -o ConnectTimeout=2 $USER@$NAME:/home/$USER/.ssh/id_rsa.pub .ssh/sub_node.pub

        for SUBNODE in `cat nodeips.txt`; do
                sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$SUBNODE 'mkdir -p .ssh'
                cat .ssh/sub_node.pub | sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$SUBNODE 'cat >> .ssh/authorized_keys'
        done
        sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME 'chmod 700 .ssh/'
        sshpass -p $PASS ssh -o ConnectTimeout=2 $USER@$NAME 'chmod 640 .ssh/authorized_keys'

done

touch ./passwordless-ssh.completed
