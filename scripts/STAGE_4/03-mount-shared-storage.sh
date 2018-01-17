#!/bin/bash

mntpoint=$6
exportedfs=$5
remotehost=$4
password=$3
username=$2
hostname=$1
remotefs=nfs

echo "#!/bin/bash

mkdir $mntpoint
mount -t $remotefs $remotehost:$exportedfs $mntpoint -o rw,user,exec,nosuid
chmod 777 $mntpoint
echo "$remotehost:$exportedfs   $mntpoint       $remotefs       defaults 0 0" | sudo tee --append /etc/fstab
" > ./mountingsequence.sh
chmod +x mountingsequence.sh

scp mountingsequence.sh $username@$hostname:/home/$username
ssh -t $username@$hostname "sudo ./mountingsequence.sh"

touch ./mount-shared-storage.completed
