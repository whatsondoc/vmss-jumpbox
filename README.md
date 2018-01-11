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

Once created, you'll want to scp the passwordless-ssh.sh script to the jumpbox node, and run it using the following syntax:
 
<b>SYNTAX:</b>        $ ./passwordless-ssh.sh <_username_> <_password_> <_ip_prefix_>

<b>EXAMPLE:</b>       $ ./passwordless-ssh.sh benji 3xamplePassword! 10.0.0

A few packages are required for the user-authentication.sh script to function properly: epel-release, nmap & sshpass. epel-release & nmap can be installed via yum first, but sshpass comes from the epel-release repo, so you'll need to re-run yum install to have the epel-release repo populate (so we can grab sshpass).
