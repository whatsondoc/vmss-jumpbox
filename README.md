# Azure: VMSS compute nodes & jumpbox server

Modified version from the Azure quickstart templates:

- Allows for multiple repeat uses of the deployment template (all created entities have largely uniquely generated names)
- Allows for creation of a new vnet (along with new storage account) or to deploy all VMs into an existing vnet and subnet
- HPC optimised; parameter files have options for A8/A9 and H16r instances. Other VM SKUs can be added if necessary. HPC specific OS distros also added as choice options
- Jumpbox has a different VM SKU than the VMSS compute nodes
- user-authentication.sh has been modified slightly to add a reminder for pre-reqs and syntax, and to reference variables as opposed to hardcoded values


The deployment process will be as follows (using the Azure CLI):
 
<b>SYNTAX:</b>        $ az group create --location <_location_> --name <_RG_name_>

<b>EXAMPLE:</b>       $ az group create --location southcentralus --name h16-compute

<b>SYNTAX:</b>        $ az group deployment create --resource-group <_RG_name_> --template-file <_path_to_azuredeploy_<vnet-option>.json_> --parameters <_path_to_params_file_>

<b>EXAMPLE:</b>       $ az group deployment create --resource-group h16r-compute --template-file azuredeploy-newvnet.json --parameters azuredeploy-newvnet-ER.parameters.json


Once the infrastructure has been created, there are a few nested scripts that offer various configuration options. You can scp these scripts to your jumpbox/headnode using scp:

SYNTAX:        $ scp -r vmss-jumpbox/scripts/* <username>@<public_ip>:/home/<username>

EXAMPLE:       $ scp -r vmss-jumpbox/scripts/* useradmin@10.11.12.13:/home/useradmin

You will be prompted to verify authenticity of the remote host the first time you try to connect.

Details of these configuration scripts are as follows:

<b>1_passwordless-ssh:</b> Allowing all nodes in the environment to communicate with each out without the need for a password
 
SYNTAX:        $ 1_passwordless-ssh/passwordless-ssh.sh

NOTES:
A few packages are required for the user-authentication.sh script to function properly: epel-release, nmap & sshpass. epel-release & nmap can be installed via yum first, but sshpass comes from the epel-release repo, so you'll need to re-run yum install to have the epel-release repo populate (so we can grab sshpass).

<b>2_add-data-disks:</b> Create an arbitrary number of data disks which are attached to a single VM

SYNTAX:       $ 2_add-data-disks/add-data-disks.sh

NOTES:
This script attaches unmanaged disks to a single VM using the Azure CLI.
Bear in mind the maximum number of disks that can be attached to the VM. The script will error out beyond this message but it will be clean.
Currently the script asks for a user definable number of disks, however this does not actually take effect. The number of disks will need to be updated in the for loop in the script (update pending for the loop to reference the user defined variable).

<b>3_create-mdadm:</b> Takes the disks added in the previous stage, creates an mdadm array (RAID 0), creates a filesystem, mounts it to a directory and exports it to a specific network segment

SYNTAX:      $ 3_create-mdadm/create-mdadm.sh

NOTES:
Collects all disks that are not /dev/sda (boot disk) or /dev/sdb (ephemeral disk) and adds these to the mdadm array. 
Has a default chunk size of 256KB, although this can be changed by amending the script to reflect the chunk size of your choosing.
Device array created as /dev/md0, but the UUID is used in /etc/fstab for persistent mounting.
Filesystem tuning may be required to better support certain scenarios. Please update the script to reflect any necessary customisation.
Amend the script if you require other specific export options: (rw,sync) are included the script.
Permissions on the share are set to 777 - amend if this does not fit the use case.

<b>4_mount-shared-storage:</b> Mounts the exported filesystem to all compute node instances in the scale set

SYNTAX:      $ 4_mount-shared-storage/mount-shared-storage.sh

NOTES:
Basic mount options included as default in the script: rw,user,exec,nosuid
Amend if other specific mount options are required.

<b>5_create-users:</b> Creates a set of users on each scale set node instance from a users.txt file on the head node.

SYNTAX:      $ 5_create-users/create-users.sh

NOTES:
Requires users.txt and nodenames.txt (the latter comes as output from 1_passwordless-ssh).
The users.txt file needs to be prepared prior to invoking; user(s), password(s), UID(s), GID(s), info, home directory and shell need populating. All commented lines need to be removed.
users.txt is copied to the home directory of the user provided during the script and remains there. If this is a security issue, consider removing the files from each node.
