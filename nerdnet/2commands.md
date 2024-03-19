# commands that are used during setup


For passwords i use JALLA! as a placeholder. This is not the password i use.

## 1 CAF naming conventions

### 1.1 CAF naming convention for the Azure Functions

Functions need to be named in a CAF compliant way:

Name: func-api-testfunction-int001-eus-01

```text
func: Indicates the resource is a Function App.
api: Denotes the integration landing zone.
testfunction: Specifies the name of the function app.
int001: The unique IntegrationID from in our tracking system.
eus: The region abbreviation for East US.
01: a two char hex to make the name unique. An instance or sequence number for versioning or multiple instances.
```

### 1.2 CAF naming convention for Azure Storage accounts

Azure Storage account names must be between 3 and 24 characters in length and can contain only lowercase letters and numbers. And it must be unique across all of Azure.

Name: stapitestfnint001eus01

```text
st: 2 char that denotes it's a storage account.
api: max 4 char that indicate landing zone.  Indicates it's part of the api landing zone.
testfn: 6 char for the name 
int001: 6 char Integration ID 
eus: 3 char that Specifies the Azure region (East US) for the storage account.
01: a two char hex to make the name unique.
```

The above rule will use the maximum length of 24 characters.

Functions have separate storage accounts so that different teams do not interfere with each other. This is a best practice for isolation and security.
TODO: check the costs of this.

### 1.3 CAF naming convention for Azure Resource Groups

TODO: is this correct for resource groups?
Name: rg-terchris-arck-rg-eus

```text
rg: 2 char that denotes it's a resource group.
terchris: 8 char for the name of the owner.
arck: 4 char for the name of the project.
rg: 2 char for the name of the resource group.
eus: 3 char that Specifies the Azure region (East US) for the resource group.
```

### 1.4 CAF naming convention for Vnet and subnets

Name: vnet-eus

```text
vnet: 4 char that denotes it's a virtual network.
eus: 3 char that Specifies the Azure region (East US) for the virtual network.
```

Name: api-appgw-sn01-eus

```text
api: 3 char that denotes it's the api landing zone.
appgw: 5 char that denotes it's an application gateway.
sn01: 4 char that denotes it's the first subnet in the api landing zone.
eus: 3 char that Specifies the Azure region (East US) for the subnet.
```

### 1.5 CAF naming convention for Application Gateway

Name: appgw-eus

```text
appgw: 5 char that denotes it's an application gateway.
eus: 3 char that Specifies the Azure region (East US) for the application gateway.
```

### 1.6 CAF naming convention for VMs

Name: nerd-vm01-eus

```text
nerd: 4 char that denotes it's the nerd landing zone.
vm01: 4 char that denotes it's the first VM in the nerd landing zone.
eus: 3 char that Specifies the Azure region (East US) for the VM.
```

### 1.7 CAF naming convention for Azure Kubernetes Service (AKS)

Name: aks-k8s-np-nerdmeet-eus

```text
aks: 3 char that denotes it's an Azure Kubernetes Service.
k8s: 3 char that denotes it's the k8s landing zone.
np: 2 char that denotes it's a non-production environment.
nerdmeet: 8 char that denotes the project or application name.
eus: 3 char that Specifies the Azure region (East US) for the AKS.
```






## Task 2: Create the resource group

```bash
az group create --name rg-terchris-arck-rg-eus --location eastus
```

output is:

```json
{
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus",
  "location": "eastus",
  "managedBy": null,
  "name": "rg-terchris-arck-rg-eus",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

## Task 3: Network Infrastructure Setup

There will be one virtual network (VNet) with three subnets. One for each landing zone.

### 3.1 Create the Virtual Network (VNet)

```bash
az network vnet create --name vnet-eus --resource-group rg-terchris-arck-rg-eus --location eastus --address-prefix 10.21.0.0/16
```

output is:

```json
{
  "newVNet": {
    "addressSpace": {
      "addressPrefixes": [
        "10.21.0.0/16"
      ]
    },
    "enableDdosProtection": false,
    "etag": "W/\"f646d480-f414-4c7a-85dd-8bb87be73d93\"",
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus",
    "location": "eastus",
    "name": "vnet-eus",
    "provisioningState": "Succeeded",
    "resourceGroup": "rg-terchris-arck-rg-eus",
    "resourceGuid": "eab4dcad-373e-4740-8f7d-2b4b92aeb8fe",
    "subnets": [],
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": []
  }
}
```

### 3.2 Define and Create Subnets for Each Landing Zone

#### API Landing Zone Subnet

Subnet Name: api-appgw-sn01-eus
Address Space: 10.21.0.0/24
Create the subnet with the following command:

```bash
az network vnet subnet create --name api-appgw-sn01-eus --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --address-prefix 10.21.0.0/24
```

output is:

```json
{
  "addressPrefix": "10.21.0.0/24",
  "delegations": [],
  "etag": "W/\"06bc24b8-bf0c-46e4-ae2b-703ba886a032\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/api-appgw-sn01-eus",
  "name": "api-appgw-sn01-eus",
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```

#### Nerdmeet Landing Zone Subnet

Subnet Name: nerd-backend-sn01-eus
Address Space: 10.21.1.0/24
Create the subnet with the following command:

```bash
az network vnet subnet create --name nerd-backend-sn01-eus --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --address-prefix 10.21.1.0/24
```

output is:

```json
{
  "addressPrefix": "10.21.1.0/24",
  "delegations": [],
  "etag": "W/\"d60a77e0-4fa7-499a-b84e-c0fec6b22ef2\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/nerd-backend-sn01-eus",
  "name": "nerd-backend-sn01-eus",
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```

#### Kubernetes Landing Zone Subnet

Subnet Name: k8s-backend-sn01-eus
Address Space: 10.21.2.0/24
Create the subnet with the following command:

```bash
az network vnet subnet create --name k8s-backend-sn01-eus --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --address-prefix 10.21.2.0/24
```

output is:

```json
{
  "addressPrefix": "10.21.2.0/24",
  "delegations": [],
  "etag": "W/\"6747a5a3-a079-4376-8614-9488a1eb952a\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/k8s-backend-sn01-eus",
  "name": "k8s-backend-sn01-eus",
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```

### 3.3 Verification of what is created

List the Virtual Network

```bash
az network vnet list --resource-group rg-terchris-arck-rg-eus --output table
```

output is:

```text
Name      ResourceGroup            Location    NumSubnets    Prefixes      DnsServers    DDOSProtection    VMProtection
--------  -----------------------  ----------  ------------  ------------  ------------  ----------------  --------------
vnet-eus  rg-terchris-arck-rg-eus  eastus      3             10.21.0.0/16                False
```

List the Subnets

```bash
az network vnet subnet list --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --output table
```

output is:

```text
AddressPrefix    Name                   PrivateEndpointNetworkPolicies    PrivateLinkServiceNetworkPolicies    ProvisioningState    ResourceGroup
---------------  ---------------------  --------------------------------  -----------------------------------  -------------------  -----------------------
10.21.0.0/24     api-appgw-sn01-eus     Disabled                          Enabled                              Succeeded            rg-terchris-arck-rg-eus
10.21.1.0/24     nerd-backend-sn01-eus  Disabled                          Enabled                              Succeeded            rg-terchris-arck-rg-eus
10.21.2.0/24     k8s-backend-sn01-eus   Disabled                          Enabled                              Succeeded            rg-terchris-arck-rg-eus
```

Verify Specific Resource Details

If you need to inspect a specific subnet more closely, you can use the command below by replacing <subnet-name> with the name of the subnet you want to investigate (e.g., api-appgw-sn01-eus).

```bash
az network vnet subnet show --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --name <subnet-name>
```

## Task 4: Application Gateway Configuration

All traffic to the landing zones will be routed through an Application Gateway. The Application Gateway will be configured to route traffic based on the subdomain.

### 4.1 Deploy Public IP for Application Gateway

Create Public IP Address:

```bash
az network public-ip create --name appgw-pip-eus --resource-group rg-terchris-arck-rg-eus --allocation-method Static --sku Standard --location eastus
```

output is:

```json
[Coming breaking change] In the coming release, the default behavior will be changed as follows when sku is Standard and zone is not provided: For zonal regions, you will get a zone-redundant IP indicated by zones:["1","2","3"]; For non-zonal regions, you will get a non zone-redundant IP indicated by zones:null.
{
  "publicIp": {
    "ddosSettings": {
      "protectionMode": "VirtualNetworkInherited"
    },
    "etag": "W/\"20d01384-72de-4278-bc47-4ea16551c5eb\"",
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/publicIPAddresses/appgw-pip-eus",
    "idleTimeoutInMinutes": 4,
    "ipAddress": "23.96.119.221",
    "ipTags": [],
    "location": "eastus",
    "name": "appgw-pip-eus",
    "provisioningState": "Succeeded",
    "publicIPAddressVersion": "IPv4",
    "publicIPAllocationMethod": "Static",
    "resourceGroup": "rg-terchris-arck-rg-eus",
    "resourceGuid": "55071ab5-f8bb-4af3-9160-57d8f9e216d8",
    "sku": {
      "name": "Standard",
      "tier": "Regional"
    },
    "type": "Microsoft.Network/publicIPAddresses"
  }
}
```

IP Address is: 23.96.119.221

### 4.2 Create SSL Certificate for *.christensen.no

Create the SSL certificate for the wildcard domain *.christensen.no using Certbot. And convert it to a PFX file.

This is described in the file [3ssl-create.md](3ssl-create.md).

## Task 5: nerd Landing zone setup

The nerd landing zone will by default have just one VM for testing purposes. Named nerd-vm01-eus.
The VM will be placed in the subnet nerd-backend-sn01-eus and it cannot be accessed from the internet.

### 5.1 Create network for test VM

Create the network interface for the test VM.

```bash
az network nic create \
  --resource-group rg-terchris-arck-rg-eus \
  --name nerd-vm01-nic-eus \
  --vnet-name vnet-eus \
  --subnet nerd-backend-sn01-eus
```

Output is:

```json
{
  "NewNIC": {
    "auxiliaryMode": "None",
    "auxiliarySku": "None",
    "disableTcpStateTracking": false,
    "dnsSettings": {
      "appliedDnsServers": [],
      "dnsServers": [],
      "internalDomainNameSuffix": "vxolj0r4g3aepd13fnfzflvy5g.bx.internal.cloudapp.net"
    },
    "enableAcceleratedNetworking": false,
    "enableIPForwarding": false,
    "etag": "W/\"d39dcbfe-1ff1-49fd-a874-7f420b7d630b\"",
    "hostedWorkloads": [],
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/networkInterfaces/nerd-vm01-nic-eus",
    "ipConfigurations": [
      {
        "etag": "W/\"d39dcbfe-1ff1-49fd-a874-7f420b7d630b\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/networkInterfaces/nerd-vm01-nic-eus/ipConfigurations/ipconfig1",
        "name": "ipconfig1",
        "primary": true,
        "privateIPAddress": "10.21.1.4",
        "privateIPAddressVersion": "IPv4",
        "privateIPAllocationMethod": "Dynamic",
        "provisioningState": "Succeeded",
        "resourceGroup": "rg-terchris-arck-rg-eus",
        "subnet": {
          "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/nerd-backend-sn01-eus",
          "resourceGroup": "rg-terchris-arck-rg-eus"
        },
        "type": "Microsoft.Network/networkInterfaces/ipConfigurations"
      }
    ],
    "location": "eastus",
    "name": "nerd-vm01-nic-eus",
    "nicType": "Standard",
    "provisioningState": "Succeeded",
    "resourceGroup": "rg-terchris-arck-rg-eus",
    "resourceGuid": "d911d038-d8ec-43ce-b933-ae77fb345683",
    "tapConfigurations": [],
    "type": "Microsoft.Network/networkInterfaces",
    "vnetEncryptionSupported": false
  }
}
```


### 5.2 Create one simple test VM

Create the cheapest test VM in the nerd landing zone.
It only purpose is to run a simple web server so that we can test the Application Gateway.
It uses [cloud-init.txt](./landing-nerd/cloud-init.txt) to install a simple web server.

Username: terchris
Name: nerd-vm01-eus

```bash
az vm create \
  --resource-group rg-terchris-arck-rg-eus \
  --name nerd-vm01-eus \
  --nics nerd-vm01-nic-eus \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username terchris \
  --generate-ssh-keys \
  --custom-data ./landing-nerd/cloud-init.txt \
  --location eastus
```

Output is:

```json
{
  "fqdns": "",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Compute/virtualMachines/nerd-vm01-eus",
  "location": "eastus",
  "macAddress": "00-0D-3A-16-D5-7B",
  "powerState": "VM running",
  "privateIpAddress": "10.21.1.4",
  "publicIpAddress": "",
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "zones": ""
}
```

### 5.3 Verify the VM is created

verify the VM is created and running:

```bash
az vm list --resource-group rg-terchris-arck-rg-eus --output table
```

output is:

```text
Name           ResourceGroup            Location    Zones
-------------  -----------------------  ----------  -------
nerd-vm01-eus  rg-terchris-arck-rg-eus  eastus
```

Check that the web server is running on the VM:

```bash
az vm run-command invoke --command-id RunShellScript --name nerd-vm01-eus --resource-group rg-terchris-arck-rg-eus --scripts "curl http://localhost"
```

output is:

```json
{
  "value": [
    {
      "code": "ProvisioningState/succeeded",
      "displayStatus": "Provisioning succeeded",
      "level": "Info",
      "message": "Enable succeeded: \n[stdout]\nHello World from host nerd-vm01-eus!\n[stderr]\n  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current\n                                 Dload  Upload   Total   Spent    Left  Speed\n\r  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r100    36  100    36    0     0    633      0 --:--:-- --:--:-- --:--:--   642\n",
      "time": null
    }
  ]
}
```

## Task 6: Kubernetes Landing Zone Setup

The k8s landing zone have kubernetes installed and running. The cluster will just havea test container running.
The container will be a simple web server that returns the hostname of the container.
The cluster be placed on the subnet k8s-backend-sn01-eus and it cannot be accessed from the internet.

We will create it as a free tier cluster.

### 6.1 Create the AKS cluster

name: aks-k8s-np-nerdmeet-eus

* aks-k8s-np-nerdmeet-eus Explanation:
* aks: Azure Kubernetes Service.
* k8s: Kubernetes.
* np: Non-production. Indicating this is intended for development,testing, or staging environments.
* nerdmeet: The project or application name.
* eus: East US. The Azure region identifier.

In order to connect the cluster to the subnet k8s-backend-sn01-eus we need to know the subscription id:

```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo $SUBSCRIPTION_ID
```

Create the AKS cluster with the following command:

```bash
az aks create \
  --resource-group rg-terchris-arck-rg-eus \
  --name aks-k8s-np-nerdmeet-eus \
  --enable-managed-identity \
  --node-count 1 \
  --generate-ssh-keys \
  --network-plugin azure \
  --vnet-subnet-id /subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/k8s-backend-sn01-eus \
  --location eastus \
  --tier Free

```

Output is:

```json
docker_bridge_cidr is not a known attribute of class <class 'azure.mgmt.containerservice.v2024_01_01.models._models_py3.ContainerServiceNetworkProfile'> and will be ignored
{
  "aadProfile": null,
  "addonProfiles": null,
  "agentPoolProfiles": [
    {
      "availabilityZones": null,
      "capacityReservationGroupId": null,
      "count": 1,
      "creationData": null,
      "currentOrchestratorVersion": "1.27.9",
      "enableAutoScaling": false,
      "enableEncryptionAtHost": false,
      "enableFips": false,
      "enableNodePublicIp": false,
      "enableUltraSsd": false,
      "gpuInstanceProfile": null,
      "hostGroupId": null,
      "kubeletConfig": null,
      "kubeletDiskType": "OS",
      "linuxOsConfig": null,
      "maxCount": null,
      "maxPods": 30,
      "minCount": null,
      "mode": "System",
      "name": "nodepool1",
      "networkProfile": null,
      "nodeImageVersion": "AKSUbuntu-2204gen2containerd-202403.04.0",
      "nodeLabels": null,
      "nodePublicIpPrefixId": null,
      "nodeTaints": null,
      "orchestratorVersion": "1.27.9",
      "osDiskSizeGb": 128,
      "osDiskType": "Managed",
      "osSku": "Ubuntu",
      "osType": "Linux",
      "podSubnetId": null,
      "powerState": {
        "code": "Running"
      },
      "provisioningState": "Succeeded",
      "proximityPlacementGroupId": null,
      "scaleDownMode": null,
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "spotMaxPrice": null,
      "tags": null,
      "type": "VirtualMachineScaleSets",
      "upgradeSettings": {
        "drainTimeoutInMinutes": null,
        "maxSurge": null,
        "nodeSoakDurationInMinutes": null
      },
      "vmSize": "Standard_DS2_v2",
      "vnetSubnetId": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/k8s-backend-sn01-eus",
      "workloadRuntime": null
    }
  ],
  "apiServerAccessProfile": null,
  "autoScalerProfile": null,
  "autoUpgradeProfile": {
    "nodeOsUpgradeChannel": "NodeImage",
    "upgradeChannel": null
  },
  "azureMonitorProfile": null,
  "azurePortalFqdn": "aks-k8s-np-rg-terchris-arck-2c39e3-vbeqdslw.portal.hcp.eastus.azmk8s.io",
  "currentKubernetesVersion": "1.27.9",
  "disableLocalAccounts": false,
  "diskEncryptionSetId": null,
  "dnsPrefix": "aks-k8s-np-rg-terchris-arck-2c39e3",
  "enablePodSecurityPolicy": null,
  "enableRbac": true,
  "extendedLocation": null,
  "fqdn": "aks-k8s-np-rg-terchris-arck-2c39e3-vbeqdslw.hcp.eastus.azmk8s.io",
  "fqdnSubdomain": null,
  "httpProxyConfig": null,
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourcegroups/rg-terchris-arck-rg-eus/providers/Microsoft.ContainerService/managedClusters/aks-k8s-np-nerdmeet-eus",
  "identity": {
    "delegatedResources": null,
    "principalId": "b77fb1ed-a785-461d-a3fa-1a98a9c477f2",
    "tenantId": "bbb10281-563a-439a-8984-058647a46d2c",
    "type": "SystemAssigned",
    "userAssignedIdentities": null
  },
  "identityProfile": {
    "kubeletidentity": {
      "clientId": "276900f6-bd6c-4c90-8562-6dfcd0798537",
      "objectId": "a8cfa44e-33ac-4a04-8ed7-09666c95aac6",
      "resourceId": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourcegroups/MC_rg-terchris-arck-rg-eus_aks-k8s-np-nerdmeet-eus_eastus/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks-k8s-np-nerdmeet-eus-agentpool"
    }
  },
  "ingressProfile": null,
  "kubernetesVersion": "1.27",
  "linuxProfile": {
    "adminUsername": "azureuser",
    "ssh": {
      "publicKeys": [
        {
          "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClvZAFmBnZ4sDWSogSi4Uo/yxb8pTTK6YSL8vUtF94P52Ff4OqoEowCx3Tz+MCszNjiaKo5qliRkpBp4XR+9DOCh0eS/LwHLnwdCfiyH+5oT7a/lyzy4uLXSJgH0PCLUg3kXi7kKYbRZfD6M/rRxTy1B7+9QGrOijNj7T8Nh2R0PZ8D5a6kpBUermm03PE1cP5GLwH7goEPotwrW5Ss2+ZJYAYXLF+9pPr01bnhIU1r8ZBR+D0lUs0NXYmOKYW+ATb1lUTaqLJmrsX/pgNYW9sgia8q3JsvwKft2G974QE4gSWz5x9CawNrfghh8Jrl8hjXiSXReTqrmD15YxpVhQd"
        }
      ]
    }
  },
  "location": "eastus",
  "maxAgentPools": 100,
  "name": "aks-k8s-np-nerdmeet-eus",
  "networkProfile": {
    "dnsServiceIp": "10.0.0.10",
    "ipFamilies": [
      "IPv4"
    ],
    "loadBalancerProfile": {
      "allocatedOutboundPorts": null,
      "backendPoolType": "nodeIPConfiguration",
      "effectiveOutboundIPs": [
        {
          "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/MC_rg-terchris-arck-rg-eus_aks-k8s-np-nerdmeet-eus_eastus/providers/Microsoft.Network/publicIPAddresses/d59d8dcd-aab1-4f3a-8cfa-feb08f3b892a",
          "resourceGroup": "MC_rg-terchris-arck-rg-eus_aks-k8s-np-nerdmeet-eus_eastus"
        }
      ],
      "enableMultipleStandardLoadBalancers": null,
      "idleTimeoutInMinutes": null,
      "managedOutboundIPs": {
        "count": 1,
        "countIpv6": null
      },
      "outboundIPs": null,
      "outboundIpPrefixes": null
    },
    "loadBalancerSku": "Standard",
    "natGatewayProfile": null,
    "networkDataplane": "azure",
    "networkMode": null,
    "networkPlugin": "azure",
    "networkPluginMode": null,
    "networkPolicy": null,
    "outboundType": "loadBalancer",
    "podCidr": null,
    "podCidrs": null,
    "serviceCidr": "10.0.0.0/16",
    "serviceCidrs": [
      "10.0.0.0/16"
    ]
  },
  "nodeResourceGroup": "MC_rg-terchris-arck-rg-eus_aks-k8s-np-nerdmeet-eus_eastus",
  "oidcIssuerProfile": {
    "enabled": false,
    "issuerUrl": null
  },
  "podIdentityProfile": null,
  "powerState": {
    "code": "Running"
  },
  "privateFqdn": null,
  "privateLinkResources": null,
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "resourceUid": "65f95b62ee972c0001c211fd",
  "securityProfile": {
    "azureKeyVaultKms": null,
    "defender": null,
    "imageCleaner": null,
    "workloadIdentity": null
  },
  "serviceMeshProfile": null,
  "servicePrincipalProfile": {
    "clientId": "msi",
    "secret": null
  },
  "sku": {
    "name": "Base",
    "tier": "Free"
  },
  "storageProfile": {
    "blobCsiDriver": null,
    "diskCsiDriver": {
      "enabled": true
    },
    "fileCsiDriver": {
      "enabled": true
    },
    "snapshotController": {
      "enabled": true
    }
  },
  "supportPlan": "KubernetesOfficial",
  "systemData": null,
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusters",
  "upgradeSettings": null,
  "windowsProfile": {
    "adminPassword": null,
    "adminUsername": "azureuser",
    "enableCsiProxy": true,
    "gmsaProfile": null,
    "licenseType": null
  },
  "workloadAutoScalerProfile": {
    "keda": null,
    "verticalPodAutoscaler": null
  }
}
```

### 6.2 Get Credentials for the cluster

Get the credentials for the AKS cluster with the following command:

```bash
az aks get-credentials --resource-group rg-terchris-arck-rg-eus --name aks-k8s-np-nerdmeet-eus
```

Output is:

```text
Merged "aks-k8s-np-nerdmeet-eus" as current context in /Users/terchris/.kube/config
```

Be aware that this file is needed to connect to the cluster.

### 6.3 Install kubectl for managing the AKS cluster

In order to connect to the AKS cluster, you need to install the Azure CLI extension for Kubernetes.
For mac install do:

```bash
brew install kubectl
```

Test that you can connect to the cluster:

```bash
kubectl get nodes
```

Output is:

```text
NAME                                STATUS   ROLES   AGE   VERSION
aks-nodepool1-34366886-vmss000000   Ready    agent   20m   v1.27.9
```

There is a good tool for working with the cluster named [k9s](https://k9scli.io/) Install it with:

```bash
brew install k9s
```

### 6.4 Verifying the cluster

We will set up ngnix in the cluster and verify that it is running.
A simple nginx definition is in the file [test-nginx.yaml](./landing-k8s/test-nginx.yaml).

Create the nginx deployment with the following command:

```bash
kubectl apply -f ./landing-k8s/test-nginx.yaml
```

Output is:

```text
deployment.apps/nginx-deployment created
service/nginx-service created
```

Verify that the deployment is running:

```bash
kubectl get pods
```

Output is:

```text
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-57d84f57dc-gqjx7   1/1     Running   0          49s
```

Displaying the web page from the nginx deployment.
To do this we must first forward the port from the cluster to the local machine.

This command forwards the port 80 from the nginx-service to the local port 8080:

```bash
kubectl port-forward service/nginx-service 8080:80
```

Output is:

```text
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

Open a browser and go to [http://localhost:8080](http://localhost:8080) and you should see the nginx welcome page.
Or use curl:

```bash
curl http://localhost:8080
```

To stop the port forwarding use `ctrl-c`.

You can also delete the deployment with:

```bash
kubectl delete -f ./landing-k8s/test-nginx.yaml
```

But leave it running as we will need it when testing the application gateway.

## Task 7: api Landing Zone Setup

The api landing zone will have an API Management service (APIM).
The APIM will get its traffic from the Application Gateway and it will be placed in the subnet api-appgw-sn01-eus and it cannot be accessed from the internet.

There will also be two Azure functions that will be used to test the APIM. The Azure functions will be placed in the subnet api-appgw-sn01-eus and they cannot be accessed from the internet.

It is best to set up Azure Functions first and make sure they work before adding them to APIM.

### 7.1 Create the Azure Storage Account

Each function will need a storage account to store the function code and logs. Functions have separate storage accounts so that different teams do not interfere with each other. This is a best practice for isolation and security.

A storage account is only available in the subnet where the function is located. 
TODO: this is strict - check it out.

Storage account for the test function named func-api-testfunction-int001-eus-01 is named: stapitestfnint001eus01

Create the storage account with the following command:

```bash
az storage account create \
  --name stapitestfnint001eus01 \
  --resource-group rg-terchris-arck-rg-eus \
  --location eastus \
  --sku Standard_LRS
```

Output is:

```json
{
  "accessTier": "Hot",
  "accountMigrationInProgress": null,
  "allowBlobPublicAccess": false,
  "allowCrossTenantReplication": false,
  "allowSharedKeyAccess": null,
  "allowedCopyScope": null,
  "azureFilesIdentityBasedAuthentication": null,
  "blobRestoreStatus": null,
  "creationTime": "2024-03-19T11:15:09.879667+00:00",
  "customDomain": null,
  "defaultToOAuthAuthentication": null,
  "dnsEndpointType": null,
  "enableHttpsTrafficOnly": true,
  "enableNfsV3": null,
  "encryption": {
    "encryptionIdentity": null,
    "keySource": "Microsoft.Storage",
    "keyVaultProperties": null,
    "requireInfrastructureEncryption": null,
    "services": {
      "blob": {
        "enabled": true,
        "keyType": "Account",
        "lastEnabledTime": "2024-03-19T11:15:11.129664+00:00"
      },
      "file": {
        "enabled": true,
        "keyType": "Account",
        "lastEnabledTime": "2024-03-19T11:15:11.129664+00:00"
      },
      "queue": null,
      "table": null
    }
  },
  "extendedLocation": null,
  "failoverInProgress": null,
  "geoReplicationStats": null,
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Storage/storageAccounts/stapitestfnint001eus01",
  "identity": null,
  "immutableStorageWithVersioning": null,
  "isHnsEnabled": null,
  "isLocalUserEnabled": null,
  "isSftpEnabled": null,
  "isSkuConversionBlocked": null,
  "keyCreationTime": {
    "key1": "2024-03-19T11:15:10.114045+00:00",
    "key2": "2024-03-19T11:15:10.114045+00:00"
  },
  "keyPolicy": null,
  "kind": "StorageV2",
  "largeFileSharesState": null,
  "lastGeoFailoverTime": null,
  "location": "eastus",
  "minimumTlsVersion": "TLS1_0",
  "name": "stapitestfnint001eus01",
  "networkRuleSet": {
    "bypass": "AzureServices",
    "defaultAction": "Allow",
    "ipRules": [],
    "ipv6Rules": [],
    "resourceAccessRules": null,
    "virtualNetworkRules": []
  },
  "primaryEndpoints": {
    "blob": "https://stapitestfnint001eus01.blob.core.windows.net/",
    "dfs": "https://stapitestfnint001eus01.dfs.core.windows.net/",
    "file": "https://stapitestfnint001eus01.file.core.windows.net/",
    "internetEndpoints": null,
    "microsoftEndpoints": null,
    "queue": "https://stapitestfnint001eus01.queue.core.windows.net/",
    "table": "https://stapitestfnint001eus01.table.core.windows.net/",
    "web": "https://stapitestfnint001eus01.z13.web.core.windows.net/"
  },
  "primaryLocation": "eastus",
  "privateEndpointConnections": [],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "routingPreference": null,
  "sasPolicy": null,
  "secondaryEndpoints": null,
  "secondaryLocation": null,
  "sku": {
    "name": "Standard_LRS",
    "tier": "Standard"
  },
  "statusOfPrimary": "available",
  "statusOfSecondary": null,
  "storageAccountSkuConversionStatus": null,
  "tags": {},
  "type": "Microsoft.Storage/storageAccounts"
}
````

### 7.1.1 Securing Azure Storage Account

TODO: This is not done yet.

To set the storage account to only be accessible from the subnet api-backend-sn01-eus we need to get the subnet id:

```bash
APISUBNET_ID=$(az network vnet subnet show --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --name api-appgw-sn01-eus --query id -o tsv)

echo $APISUBNET_ID
```

Output is:

```text
/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/api-appgw-sn01-eus
```

Set the storage account to only be accessible from the subnet api-backend-sn01-eus with the following command:

```bash
az storage account network-rule add --resource-group rg-terchris-arck-rg-eus --account-name stapitestfnint001eus01 --subnet $APISUBNET_ID
```

Output is:

```json
?todo
```

### 7.1.2 Verifying Azure Storage Account

To verify that the storage account is created do:

```bash
az storage account list --resource-group rg-terchris-arck-rg-eus --output table
```

Output is:

```text
AccessTier    AllowBlobPublicAccess    AllowCrossTenantReplication    CreationTime                      EnableHttpsTrafficOnly    Kind       Location    MinimumTlsVersion    Name                    PrimaryLocation    ProvisioningState    ResourceGroup            StatusOfPrimary
------------  -----------------------  -----------------------------  --------------------------------  ------------------------  ---------  ----------  -------------------  ----------------------  -----------------  -------------------  -----------------------  -----------------
Hot           False                    False                          2024-03-19T11:15:09.879667+00:00  True                      StorageV2  eastus      TLS1_0               stapitestfnint001eus01  eastus             Succeeded            rg-terchris-arck-rg-eus  available
```

### 7.2 Create the Azure Functions

The Azure Functions will be used to test the APIM. The Azure functions will be placed in the subnet api-appgw-sn01-eus and they cannot be accessed from the internet.

The test function will be named: func-api-testfunction-int001-eus-01

It will use the storage account named: stapitestfnint001eus01

The function runtime is node as it will be implemented in javascript.

To save costs it is created as a consumption plan. It means that it cannot be isolated to a specific subnet. Se more below about securing the function.

```bash
az functionapp create \
  --resource-group rg-terchris-arck-rg-eus \
  --consumption-plan-location eastus \
  --runtime node \
  --functions-version 4 \
  --name func-api-testfunction-int001-eus-01 \
  --storage-account stapitestfnint001eus01
```

Output is:

```json
Application Insights "func-api-testfunction-int001-eus-01" was created for this Function App. You can visit https://portal.azure.com/#resource/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/microsoft.insights/components/func-api-testfunction-int001-eus-01/overview to view your Application Insights component
App settings have been redacted. Use `az webapp/logicapp/functionapp config appsettings list` to view.
{
  "availabilityState": "Normal",
  "clientAffinityEnabled": false,
  "clientCertEnabled": false,
  "clientCertExclusionPaths": null,
  "clientCertMode": "Required",
  "cloningInfo": null,
  "containerSize": 1536,
  "customDomainVerificationId": "02815D2A0BE1CCF3F25FD215EE6ED6B1D2A025600D1D747D111704EB2E237F2A",
  "dailyMemoryTimeQuota": 0,
  "daprConfig": null,
  "defaultHostName": "func-api-testfunction-int001-eus-01.azurewebsites.net",
  "enabled": true,
  "enabledHostNames": [
    "func-api-testfunction-int001-eus-01.azurewebsites.net",
    "func-api-testfunction-int001-eus-01.scm.azurewebsites.net"
  ],
  "extendedLocation": null,
  "hostNameSslStates": [
    {
      "certificateResourceId": null,
      "hostType": "Standard",
      "ipBasedSslResult": null,
      "ipBasedSslState": "NotConfigured",
      "name": "func-api-testfunction-int001-eus-01.azurewebsites.net",
      "sslState": "Disabled",
      "thumbprint": null,
      "toUpdate": null,
      "toUpdateIpBasedSsl": null,
      "virtualIPv6": null,
      "virtualIp": null
    },
    {
      "certificateResourceId": null,
      "hostType": "Repository",
      "ipBasedSslResult": null,
      "ipBasedSslState": "NotConfigured",
      "name": "func-api-testfunction-int001-eus-01.scm.azurewebsites.net",
      "sslState": "Disabled",
      "thumbprint": null,
      "toUpdate": null,
      "toUpdateIpBasedSsl": null,
      "virtualIPv6": null,
      "virtualIp": null
    }
  ],
  "hostNames": [
    "func-api-testfunction-int001-eus-01.azurewebsites.net"
  ],
  "hostNamesDisabled": false,
  "hostingEnvironmentProfile": null,
  "httpsOnly": false,
  "hyperV": false,
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Web/sites/func-api-testfunction-int001-eus-01",
  "identity": null,
  "inProgressOperationId": null,
  "isDefaultContainer": null,
  "isXenon": false,
  "keyVaultReferenceIdentity": "SystemAssigned",
  "kind": "functionapp",
  "lastModifiedTimeUtc": "2024-03-19T11:52:25.660000",
  "location": "eastus",
  "managedEnvironmentId": null,
  "maxNumberOfWorkers": null,
  "name": "func-api-testfunction-int001-eus-01",
  "outboundIpAddresses": "40.76.153.101,40.76.153.110,40.76.154.226,40.76.154.255,40.76.157.61,40.76.157.127,20.49.104.58",
  "possibleOutboundIpAddresses": "40.76.153.101,40.76.153.110,40.76.154.226,40.76.154.255,40.76.157.61,40.76.157.127,40.76.159.243,40.76.152.113,52.151.202.170,52.151.204.113,52.151.204.241,52.151.205.9,52.151.207.70,52.151.207.159,52.151.207.204,52.151.207.237,20.72.144.10,20.72.144.38,40.76.152.239,20.72.145.3,20.72.145.6,20.72.145.15,20.72.145.55,20.72.145.188,20.72.146.40,20.72.147.23,20.72.147.153,20.72.148.78,20.72.148.126,20.72.148.155,20.49.104.58",
  "publicNetworkAccess": null,
  "redundancyMode": "None",
  "repositorySiteName": "func-api-testfunction-int001-eus-01",
  "reserved": false,
  "resourceConfig": null,
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "scmSiteAlsoStopped": false,
  "serverFarmId": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Web/serverfarms/EastUSPlan",
  "siteConfig": {
    "acrUseManagedIdentityCreds": false,
    "acrUserManagedIdentityId": null,
    "alwaysOn": false,
    "antivirusScanEnabled": null,
    "apiDefinition": null,
    "apiManagementConfig": null,
    "appCommandLine": null,
    "appSettings": null,
    "autoHealEnabled": null,
    "autoHealRules": null,
    "autoSwapSlotName": null,
    "azureMonitorLogCategories": null,
    "azureStorageAccounts": null,
    "connectionStrings": null,
    "cors": null,
    "customAppPoolIdentityAdminState": null,
    "customAppPoolIdentityTenantState": null,
    "defaultDocuments": null,
    "detailedErrorLoggingEnabled": null,
    "documentRoot": null,
    "elasticWebAppScaleLimit": null,
    "experiments": null,
    "fileChangeAuditEnabled": null,
    "ftpsState": null,
    "functionAppScaleLimit": 0,
    "functionsRuntimeScaleMonitoringEnabled": null,
    "handlerMappings": null,
    "healthCheckPath": null,
    "http20Enabled": false,
    "http20ProxyFlag": null,
    "httpLoggingEnabled": null,
    "ipSecurityRestrictions": [
      {
        "action": "Allow",
        "description": "Allow all access",
        "headers": null,
        "ipAddress": "Any",
        "name": "Allow all",
        "priority": 2147483647,
        "subnetMask": null,
        "subnetTrafficTag": null,
        "tag": null,
        "vnetSubnetResourceId": null,
        "vnetTrafficTag": null
      }
    ],
    "ipSecurityRestrictionsDefaultAction": null,
    "javaContainer": null,
    "javaContainerVersion": null,
    "javaVersion": null,
    "keyVaultReferenceIdentity": null,
    "limits": null,
    "linuxFxVersion": "",
    "loadBalancing": null,
    "localMySqlEnabled": null,
    "logsDirectorySizeLimit": null,
    "machineKey": null,
    "managedPipelineMode": null,
    "managedServiceIdentityId": null,
    "metadata": null,
    "minTlsCipherSuite": null,
    "minTlsVersion": null,
    "minimumElasticInstanceCount": 0,
    "netFrameworkVersion": null,
    "nodeVersion": null,
    "numberOfWorkers": 1,
    "phpVersion": null,
    "powerShellVersion": null,
    "preWarmedInstanceCount": null,
    "publicNetworkAccess": null,
    "publishingPassword": null,
    "publishingUsername": null,
    "push": null,
    "pythonVersion": null,
    "remoteDebuggingEnabled": null,
    "remoteDebuggingVersion": null,
    "requestTracingEnabled": null,
    "requestTracingExpirationTime": null,
    "routingRules": null,
    "runtimeADUser": null,
    "runtimeADUserPassword": null,
    "scmIpSecurityRestrictions": [
      {
        "action": "Allow",
        "description": "Allow all access",
        "headers": null,
        "ipAddress": "Any",
        "name": "Allow all",
        "priority": 2147483647,
        "subnetMask": null,
        "subnetTrafficTag": null,
        "tag": null,
        "vnetSubnetResourceId": null,
        "vnetTrafficTag": null
      }
    ],
    "scmIpSecurityRestrictionsDefaultAction": null,
    "scmIpSecurityRestrictionsUseMain": null,
    "scmMinTlsVersion": null,
    "scmType": null,
    "sitePort": null,
    "sitePrivateLinkHostEnabled": null,
    "storageType": null,
    "supportedTlsCipherSuites": null,
    "tracingOptions": null,
    "use32BitWorkerProcess": null,
    "virtualApplications": null,
    "vnetName": null,
    "vnetPrivatePortsCount": null,
    "vnetRouteAllEnabled": null,
    "webSocketsEnabled": null,
    "websiteTimeZone": null,
    "winAuthAdminState": null,
    "winAuthTenantState": null,
    "windowsConfiguredStacks": null,
    "windowsFxVersion": null,
    "xManagedServiceIdentityId": null
  },
  "slotSwapStatus": null,
  "state": "Running",
  "storageAccountRequired": false,
  "suspendedTill": null,
  "tags": null,
  "targetSwapSlot": null,
  "trafficManagerHostNames": null,
  "type": "Microsoft.Web/sites",
  "usageState": "Normal",
  "virtualNetworkSubnetId": null,
  "vnetContentShareEnabled": false,
  "vnetImagePullEnabled": false,
  "vnetRouteAllEnabled": false,
  "workloadProfileName": null
}
```

#### 7.2.1 Securing Azure Functions

TODO: This is not done yet - are we going to use the premium plan?

To restrict a Azure Function to a subnet, VNet integration must be enabled. A functionality that is available on the Premium plan, an Elastic Premium plan, or a Dedicated (App Service) plan.

Step 1: Create an App Service Plan with Premium SKU

```bash
az appservice plan create \
  --name myPremiumPlan \
  --resource-group rg-terchris-arck-rg-eus \
  --location eastus \
  --sku P1v2 \
  --is-linux
```

Step 2: Create the Function App in the Premium Plan

```bash
az functionapp create \
  --name func-api-testfunction-int001-eus-01 \
  --storage-account stapitestfnint001eus01 \
  --resource-group rg-terchris-arck-rg-eus \
  --plan myPremiumPlan \
  --runtime node \
  --functions-version 4
```

Step 3: Enable VNet Integration for the Function App

```bash
SUBNET_ID=$(az network vnet subnet show --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --name api-appgw-sn01-eus --query id -o tsv)
```

Then, integrate your Function App with the subnet:

```bash
az webapp vnet-integration add \
  --name func-api-testfunction-int001-eus-01 \
  --resource-group rg-terchris-arck-rg-eus \
  --vnet vnet-eus \
  --subnet $SUBNET_ID
```

By following these steps, we can restrict the Azure Function to only be accessible within the specified subnet, enhancing the security posture of your application.

#### 7.2.2 Verifying Azure Functions

To verify that the function is created do:

```bash
az functionapp list --resource-group rg-terchris-arck-rg-eus --output table
```

Output is:

```text
Name                                 Location    State    ResourceGroup            DefaultHostName                                        AppServicePlan
-----------------------------------  ----------  -------  -----------------------  -----------------------------------------------------  ----------------
func-api-testfunction-int001-eus-01  East US     Running  rg-terchris-arck-rg-eus  func-api-testfunction-int001-eus-01.azurewebsites.net  EastUSPlan
```

If you need to delete the function app you can do it with this command:

```bash
az functionapp delete --name func-api-testfunction-int001-eus-01 --resource-group rg-terchris-arck-rg-eus
```

### 7.3 Adding code to the test function

In oder to test APIM we need to have api functions we can call.
The folder TestFunction contains two functions:

- TimeFunction - returns the current time
- DayOfWeekFunction - returns the current day of the week

See [readme.md](./landing-api/readme.md) file in the folder for more information about the functions.
Their internal workings, and how to test them locally.
You dont need to mess with the code. But you ned to install the tools that enable you to use the func command.

The name of the function app is: func-api-testfunction-int001-eus-01
To use the func tool you do:

```bash
cd landing-api/TestFunction

func azure functionapp publish func-api-testfunction-int001-eus-01
```

Output is:

```text
Setting Functions site property 'netFrameworkVersion' to 'v6.0'
Getting site publishing info...
[2024-03-19T13:07:13.763Z] Starting the function app deployment...
Creating archive for current directory...
Uploading 644.36 KB [#############################################################################]
Upload completed successfully.
Deployment completed successfully.
[2024-03-19T13:07:51.836Z] Syncing triggers...
Functions in func-api-testfunction-int001-eus-01:
    DayOfWeekFunction - [httpTrigger]
        Invoke url: https://func-api-testfunction-int001-eus-01.azurewebsites.net/api/dayofweekfunction

    TimeFunction - [httpTrigger]
        Invoke url: https://func-api-testfunction-int001-eus-01.azurewebsites.net/api/timefunction
```

### 7.3. Testing the functions

You can now test the functions by opening the urls in a browser.
As you see the functions are now available and open for everyone to use. No security at all.

```bash
curl https://func-api-testfunction-int001-eus-01.azurewebsites.net/api/timefunction
```

To get the configuration of the function app you can do:

```bash
az functionapp config appsettings list --name func-api-testfunction-int001-eus-01 --resource-group rg-terchris-arck-rg-eus
```

Output is:

```json
[
  {
    "name": "FUNCTIONS_WORKER_RUNTIME",
    "slotSetting": false,
    "value": "node"
  },
  {
    "name": "WEBSITE_NODE_DEFAULT_VERSION",
    "slotSetting": false,
    "value": "~20"
  },
  {
    "name": "FUNCTIONS_EXTENSION_VERSION",
    "slotSetting": false,
    "value": "~4"
  },
  {
    "name": "AzureWebJobsStorage",
    "slotSetting": false,
    "value": "DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=removed-secret"
  },
  {
    "name": "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING",
    "slotSetting": false,
    "value": "DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=removed-secret"
  },
  {
    "name": "WEBSITE_CONTENTSHARE",
    "slotSetting": false,
    "value": "func-api-testfunction-int001-eus-01d979f55903c9"
  },
  {
    "name": "APPLICATIONINSIGHTS_CONNECTION_STRING",
    "slotSetting": false,
    "value": "InstrumentationKey=f1ad1c7d-9185-468b-877a-9f103928bdc8;IngestionEndpoint=https://eastus-8.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/"
  },
  {
    "name": "WEBSITE_RUN_FROM_PACKAGE",
    "slotSetting": false,
    "value": "1"
  }
]
```


### 7.4 Create the API Management Service

We create SKU Developer as it has the networking features we need.The upcomming Standard v2 SKU is not available in the az cli yet (expected mar30 2024).

NB! It might take up to 30 minutes to create the APIM.

```bash
az apim create \
  --name apim-api-nerd-eus \
  --resource-group rg-terchris-arck-rg-eus \
  --publisher-email "terje@christensen.no" \
  --publisher-name "Christensen.no" \
  --location eastus \
  --sku-name Developer \
  --location eastus

```

Output is:

```json
{
  "additionalLocations": null,
  "apiVersionConstraint": {
    "minApiVersion": null
  },
  "certificates": null,
  "createdAtUtc": "2024-03-19T14:00:13.259016+00:00",
  "customProperties": {
    "Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2": "False",
    "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30": "False",
    "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10": "False",
    "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11": "False",
    "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168": "False",
    "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30": "False",
    "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10": "False",
    "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11": "False"
  },
  "developerPortalUrl": "https://apim-api-nerd-eus.developer.azure-api.net",
  "disableGateway": false,
  "enableClientCertificate": null,
  "etag": "AAAAAAEAGMA=",
  "gatewayRegionalUrl": "https://apim-api-nerd-eus-eastus-01.regional.azure-api.net",
  "gatewayUrl": "https://apim-api-nerd-eus.azure-api.net",
  "hostnameConfigurations": [
    {
      "certificate": null,
      "certificatePassword": null,
      "certificateSource": "BuiltIn",
      "certificateStatus": null,
      "defaultSslBinding": true,
      "encodedCertificate": null,
      "hostName": "apim-api-nerd-eus.azure-api.net",
      "identityClientId": null,
      "keyVaultId": null,
      "negotiateClientCertificate": false,
      "type": "Proxy"
    }
  ],
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.ApiManagement/service/apim-api-nerd-eus",
  "identity": null,
  "location": "East US",
  "managementApiUrl": "https://apim-api-nerd-eus.management.azure-api.net",
  "name": "apim-api-nerd-eus",
  "natGatewayState": "Disabled",
  "notificationSenderEmail": "terje@christensen.no",
  "outboundPublicIpAddresses": [
    "20.242.171.132"
  ],
  "platformVersion": "stv2",
  "portalUrl": "https://apim-api-nerd-eus.portal.azure-api.net",
  "privateEndpointConnections": null,
  "privateIpAddresses": null,
  "provisioningState": "Succeeded",
  "publicIpAddressId": null,
  "publicIpAddresses": [
    "20.242.171.132"
  ],
  "publicNetworkAccess": "Enabled",
  "publisherEmail": "terje@christensen.no",
  "publisherName": "Christensen.no",
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "restore": null,
  "scmUrl": "https://apim-api-nerd-eus.scm.azure-api.net",
  "sku": {
    "capacity": 1,
    "name": "Developer"
  },
  "systemData": {
    "createdAt": "2024-03-19T14:00:12.830235+00:00",
    "createdBy": "terchris.redcross@gmail.com",
    "createdByType": "User",
    "lastModifiedAt": "2024-03-19T14:00:12.830235+00:00",
    "lastModifiedBy": "terchris.redcross@gmail.com",
    "lastModifiedByType": "User"
  },
  "tags": {},
  "targetProvisioningState": "",
  "type": "Microsoft.ApiManagement/service",
  "virtualNetworkConfiguration": null,
  "virtualNetworkType": "None",
  "zones": null
}
```

Notice this in the output:

```text
Developer Portal URL: Access the portal for developers to learn and test your APIs. URL: https://apim-api-nerd-eus.developer.azure-api.net
Gateway Regional URL: Endpoint for the regional API gateway, enhancing performance for regional users. URL: https://apim-api-nerd-eus-eastus-01.regional.azure-api.net
Gateway URL: Main entry point for API calls to your APIM service. URL: https://apim-api-nerd-eus.azure-api.net
Management API URL: Interface for programmatically managing your APIs. URL: https://apim-api-nerd-eus.management.azure-api.net
Portal URL: Older version of the developer portal for API interaction. URL: https://apim-api-nerd-eus.portal.azure-api.net
SCM URL: Used for deployment and source control management. URL: https://apim-api-nerd-eus.scm.azure-api.net
```

List the APIMs to check if it was created and is running:

```bash
az apim list --query "[].{Name:name, Location:location, Sku:sku.name, PublisherEmail:publisherEmail}" -o table
```

Output is:

```text
Name               Location    Sku        PublisherEmail
-----------------  ----------  ---------  --------------------
apim-api-nerd-eus  East US     Developer  terje@christensen.no
```

### 7.5 Adding the Azure Functions to the APIM

#### 7.5.1 Create swagger file for the TestFunction

We will use Bicep to define the two functions in the TestFunction and Bicep needs to refer to a swagger file.
The swagger file for the two functions is in the file [testfunction.json](./landing-api/swagger/testfunction.json).

#### 7.5.2 Import the swagger file to the APIM using Bicep

We now need to add the functions to the APIM.
We are doing that using Bicep. See the file [4bicep-setup](./4bicep-setup.md) for more information on how to set it up.

The Bicep definition for setting up the two API's in TestFunction is in the file [testfunction-apis.bicep](./landing-api/apim-bicep/testfunction-apis.bicep).

To deploy the bicep file you do:
In the parent folder of the bicep file do:

```bash
az deployment group create \
  --resource-group rg-terchris-arck-rg-eus \
  --template-file ./landing-api/apim-bicep/testfunction-apis.bicep
```
