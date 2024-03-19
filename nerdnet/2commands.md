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

Storage account for the test function named func-api-testfunction-int001-eus-01 is named: stapitestfnint001eus01

```bash
az storage account create \
  --name stapitestfnint001eus01 \
  --resource-group rg-terchris-arck-rg-eus \
  --location eastus \
  --sku Standard_LRS
```


### 7.1 Create the Azure Functions

Name: func-api-testfunction-int001-eus-01








