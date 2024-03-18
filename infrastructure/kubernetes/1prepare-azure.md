# prepare-azure

Steps to set up an prepare kubernetes cluster for the nerdmeet project.

## Login and prepare Azure and kubernetes

First we must have the command line tool az installed.

### Install az if not already installed

If you are not using brew you are missing out. Install brew and then install az.

```bash
brew update && brew install azure-cli
```

### log in to azure

```bash
az login
```

A web browser will oopen and you need to log in.
After logging in you will se a list . Look for the one like this:

```json
[
 {
    "cloudName": "AzureCloud",
    "homeTenantId": "d34df49e-8ff4-46d6-b78d-3cef3261bcd6",
    "id": "2db70c5d-333e-478d-a6cc-df7cb1e83b30",
    "isDefault": false,
    "managedByTenants": [],
    "name": "PROD - IKT - AZ - RED CROSS",
    "state": "Enabled",
    "tenantId": "d34df49e-8ff4-46d6-b78d-3cef3261bcd6",
    "user": {
      "name": "terje.christensen@redcross.no",
      "type": "user"
    }
  }

]
```

You can also list the accounts and the subscriptions

```bash
az account list --output table
```

Now set "PROD - IKT - AZ - RED CROSS" as default

```bash
az account set --subscription "PROD - IKT - AZ - RED CROSS"
```

List the resource groups

```bash
az group list --output table
```

 


I have created one using the portal named: rg-test-arck-rg-euw  

### creating a cluster

The naming convention is as follows:
rc=org
ikt=Units/Depts
aks=Projects/Apps/Services (aks er azure kubernetes serv)
func=nerdmeet
tst=Environments
euw=Locations
1=Instance

So the name is: arck-rc-ikt-aks-nerdmeet-tst-euw-1

#### Create networks for the cluster

It appears that we need to create a network before we can create the cluster.
Lets create a vnet that is named nerdmeet and a subnet in it named nerdkubernetes.

```bash
az network vnet create --name nerdmeet --resource-group rg-test-arck-rg-euw --location westeurope --address-prefix 10.0.0.0/16
```

You will get the following json back:

```json
{
  "newVNet": {
    "addressSpace": {
      "addressPrefixes": [
        "10.0.0.0/16"
      ]
    },
    "enableDdosProtection": false,
    "etag": "W/\"8bcc3a09-b63f-4b62-8faf-bbd4727d82ce\"",
    "id": "/subscriptions/2db70c5d-333e-478d-a6cc-df7cb1e83b30/resourceGroups/rg-test-arck-rg-euw/providers/Microsoft.Network/virtualNetworks/nerdmeet",
    "location": "westeurope",
    "name": "nerdmeet",
    "provisioningState": "Succeeded",
    "resourceGroup": "rg-test-arck-rg-euw",
    "resourceGuid": "076988d5-8796-4d2f-bb13-5cad1dd0b4e1",
    "subnets": [],
    "tags": {
      "businessContact": "thomas.augestad@redcross.no",
      "environment": "production",
      "opsHours": "n/a",
      "opsTeam": "redeploy",
      "technicalContact": "stig.morten.eskeland@redcross.no",
      "workload": "ikt"
    },
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": []
  }
}
```

Now create the subnet

```bash
az network vnet subnet create --vnet-name nerdmeet --name nerdkubernetes --resource-group rg-test-arck-rg-euw --address-prefix 10.0.1.0/24
```

You will get the following json back:

```json
{
  "addressPrefix": "10.0.1.0/24",
  "delegations": [],
  "etag": "W/\"af2df364-be26-41c3-929a-4555cb94cc32\"",
  "id": "/subscriptions/2db70c5d-333e-478d-a6cc-df7cb1e83b30/resourceGroups/rg-test-arck-rg-euw/providers/Microsoft.Network/virtualNetworks/nerdmeet/subnets/nerdkubernetes",
  "name": "nerdkubernetes",
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "rg-test-arck-rg-euw",
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```

You can list the subnets in the vnet like this:

```bash
az network vnet show --name nerdmeet --resource-group rg-test-arck-rg-euw --output json
```

and
    
```bash
az network vnet subnet show --vnet-name nerdmeet --name nerdkubernetes --resource-group rg-test-arck-rg-euw --output json

``` 


#### Create the cluster

Now we can create the cluster. We name the cluster: nerdkube
We need to specify the subnet we created above.
Because of the security policy we must create a private cluster. Note that we cant access it from the outside.

```bash
az aks create \
    --resource-group rg-test-arck-rg-euw \
    --name nerdkube \  
    --node-count 1 \
    --network-plugin azure \
    --vnet-subnet-id /subscriptions/2db70c5d-333e-478d-a6cc-df7cb1e83b30/resourceGroups/rg-test-arck-rg-euw/providers/Microsoft.Network/virtualNetworks/nerdmeet/subnets/nerdkubernetes \
    --generate-ssh-keys \
    --enable-private-cluster
```




