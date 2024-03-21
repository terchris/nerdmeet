# cmd network-landingzones

## Network Infrastructure Setup

There will be one virtual network (VNet) with three subnets. One for each landing zone.

This file contains all commands to set up the network infrastructure for the landing zones. For overview see the [Network Landing Zones](9nerdnet-network.md) file.

### Create the Virtual Network (VNet)

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

#### Application Gateway Subnet

Subnet Name: appgw-backend-sn01-eus
Address Space: 10.21.0.0/24
Create the subnet with the following command:

```bash
az network vnet subnet create --name appgw-backend-sn01-eus --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --address-prefix 10.21.0.0/24
```


output is:

```json
{
  "addressPrefix": "10.21.0.0/24",
  "delegations": [],
  "etag": "W/\"8365826f-c6c9-4a65-8105-7a5fcfd9dbd0\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/appgw-backend-sn01-eus",
  "name": "appgw-backend-sn01-eus",
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

#### api Landing Zone Subnet

Subnet Name: api-backend-sn01-eus
Address Space: 10.21.3.0/24
Create the subnet with the following command:

```bash
az network vnet subnet create --name api-backend-sn01-eus --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --address-prefix 10.21.3.0/24
```

output is:

```json
{
  "addressPrefix": "10.21.3.0/24",
  "delegations": [],
  "etag": "W/\"8a460dc4-debd-4ad4-9361-355a950585b1\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/api-backend-sn01-eus",
  "name": "api-backend-sn01-eus",
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
AddressPrefix    Name                    PrivateEndpointNetworkPolicies    PrivateLinkServiceNetworkPolicies    ProvisioningState    ResourceGroup
---------------  ----------------------  --------------------------------  -----------------------------------  -------------------  -----------------------
10.21.1.0/24     nerd-backend-sn01-eus   Disabled                          Enabled                              Succeeded            rg-terchris-arck-rg-eus
10.21.2.0/24     k8s-backend-sn01-eus    Disabled                          Enabled                              Succeeded            rg-terchris-arck-rg-eus
10.21.3.0/24     api-backend-sn01-eus    Disabled                          Enabled                              Succeeded            rg-terchris-arck-rg-eus
10.21.0.0/24     appgw-backend-sn01-eus  Disabled                          Enabled                              Succeeded            rg-terchris-arck-rg-eus
```

Verify Specific Resource Details

If you need to inspect a specific subnet more closely, you can use the command below by replacing <subnet-name> with the name of the subnet you want to investigate (e.g., nerd-backend-sn01-eus).

```bash
az network vnet subnet show --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --name <subnet-name>
```

If you need to delete a subnet, you can use the command below by replacing <subnet-name> with the name of the subnet you want to delete (e.g., nerd-backend-sn01-eus).

```bash
az network vnet subnet delete --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --name <subnet-name>
```
