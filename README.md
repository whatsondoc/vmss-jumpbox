# Azure: VMSS compute nodes & jumpbox server

Modified version from the Azure quickstart templates:

- Allows for multiple repeat uses of the deployment template (all created entities have largely uniquely generated names)
- Allows for creation of a new vnet (along with new storage account) or to deploy all VMs into an existing vnet and subnet
- HPC optimised; parameter files have options for A8/A9 and H16r instances. Other VM SKUs can be added if necessary. HPC specific OS distros also added as choice options
- Jumpbox has a different VM SKU than the VMSS compute nodes
- user-authentication.sh has been modified slightly to add a reminder for pre-reqs and syntax, and to reference variables as opposed to hardcoded values


The deployment process will be as follows (using the Azure CLI):
 
SYNTAX:        $ az group create --location <location> --name <RG_name>

EXAMPLE:       $ az group create --location northcentralus --name h16r-compute
 
SYNTAX:        $ az group deployment create --resource-group <RG_name> --template-file <path_to_azuredeploy_<vnet-option>.json> --parameters <path_to_params_file>

EXAMPLE:       $ az group deployment create --resource-group h16r-compute --template-file azuredeploy-newvnet.json --parameters azuredeploy-newvnet-h16r.parameters.json
 
Once created, you'll want to scp the user-authentication.sh script to the jumpbox node, and run it using the following syntax:
 
SYNTAX:        $ ./user-authentication.sh <username> <password> <ip_prefix>

EXAMPLE:       $ ./user-authentication.sh benji 3xamplePassword! 10.0.0

A few packages are required for the user-authentication.sh script to function properly: epel-release, nmap & sshpass. epel-release & nmap can be installed via yum first, but sshpass comes from the epel-release repo, so you'll need to re-run yum install to have the epel-release repo populate (so we can grab sshpass).
