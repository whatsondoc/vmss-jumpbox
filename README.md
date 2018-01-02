# Azure: VMSS compute nodes & jumpbox server

Modified version from the Azure quickstart templates:

Allows for multiple repeat uses of the deployment template (all created entities have largely uniquely generated names)
Allows for creation of a new vnet (along with new storage account) or to deploy all VMs into an existing vnet and subnet
HPC optimised; parameter files have options for A8/A9 and H16r instances. Other VM SKUs can be added if necessary. HPC specific OS distros also added as choice options
Jumpbox has a different VM SKU than the VMSS compute nodes
user-authentication.sh has been modified slightly to add a reminder for pre-reqs and syntax, and to reference variables as opposed to hardcoded values
