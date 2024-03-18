# Creating CAF environment

This is a guide on how to set up a shadow of the 

I have set up an free Azure account for my email terchris.redcross@gmail.com

We will use the domain arezibo.no 

CAF defines some best practices and one of them is naming conventions.
We will use the naming conventions from CAF.


We follow the description  
[Quickstart: Direct web traffic with Azure Application Gateway - Azure CLI](https://learn.microsoft.com/en-us/azure/application-gateway/quick-create-cli)

An then we add the SSL certificate and the APIM when we know that the application gateway is working.

we create the stuff in the region eastus. This because the stuff is available anc cheapest there.


## Naming conventions

we just ask chatGPT to figure it out for us.

## Login to your Azure account

The command below will open a browser window where you can login to your Azure account.
Make SURE that you are using the correct account.

```bash
az login 
```

You will get a json back with the details of the subscription.

```json
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "bbb10281-563a-439a-8984-058647a46d2c",
    "id": "2c39e355-0751-4cdf-81d7-737b0005c0ba",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantId": "bbb10281-563a-439a-8984-058647a46d2c",
    "user": {
      "name": "terchris.redcross@gmail.com",
      "type": "user"
    }
  }
]
```


## Create resource group

The resource group has the name rg-test-arck-rg-eus accoring to the naming conventions from CAF.

```bash
az group create --name rg-test-arck-rg-eus --location eastus

```

You will get this json back:

```json
{
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus",
  "location": "eastus",
  "managedBy": null,
  "name": "rg-test-arck-rg-eus",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

To list resource groups:

```bash
az group list --output table
```




## create the landing zones

Landing zones are a concept and not something that we create using an az command.
So, when we talk about "creating a landing zone," we're referring to the process of deploying and configuring these resources in a manner that aligns with the CAF's best practices.

### Integration landing zone


#### Create the network for integration landing zone

We need a vnet and a subnet in the vnet
vnet : intg-vnet-eus
subnet : intg-appgw-sn01-eus

```bash
az network vnet create \
    --name intg-vnet-eus \
    --resource-group rg-test-arck-rg-eus \
    --location eastus \
    --address-prefix 10.21.0.0/16 \
    --subnet-name intg-appgw-sn01-eus \
    --subnet-prefix 10.21.0.0/24
```

You will get this json back:

```json
Resource provider 'Microsoft.Network' used by this operation is not registered. We are registering for you.
Registration succeeded.
{
  "newVNet": {
    "addressSpace": {
      "addressPrefixes": [
        "10.21.0.0/16"
      ]
    },
    "enableDdosProtection": false,
    "etag": "W/\"856c4bc2-5558-47dd-a5df-3450552e9021\"",
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/intg-vnet-eus",
    "location": "eastus",
    "name": "intg-vnet-eus",
    "provisioningState": "Succeeded",
    "resourceGroup": "rg-test-arck-rg-eus",
    "resourceGuid": "22a91720-e767-41c4-9b87-eb50da09fd66",
    "subnets": [
      {
        "addressPrefix": "10.21.0.0/24",
        "delegations": [],
        "etag": "W/\"856c4bc2-5558-47dd-a5df-3450552e9021\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/intg-vnet-eus/subnets/intg-appgw-sn01-eus",
        "name": "intg-appgw-sn01-eus",
        "privateEndpointNetworkPolicies": "Disabled",
        "privateLinkServiceNetworkPolicies": "Enabled",
        "provisioningState": "Succeeded",
        "resourceGroup": "rg-test-arck-rg-eus",
        "type": "Microsoft.Network/virtualNetworks/subnets"
      }
    ],
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": []
  }
}
```

#### Create the backend subnet

Named intg-backend-sn01-eus

```bash
az network vnet subnet create \
    --name intg-backend-sn01-eus \
    --resource-group rg-test-arck-rg-eus \
    --vnet-name intg-vnet-eus \
    --address-prefix 10.21.1.0/24
```

You will get this json back:

```json
{
  "addressPrefix": "10.21.1.0/24",
  "delegations": [],
  "etag": "W/\"20e01ebe-765c-40d7-9e18-ef2128708d60\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/intg-vnet-eus/subnets/intg-backend-sn01-eus",
  "name": "intg-backend-sn01-eus",
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "rg-test-arck-rg-eus",
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```

#### Check the networks

You can list the vnet and subnet like this:

```bash
az network vnet list --resource-group rg-test-arck-rg-eus --output table
```

You will get this table back:

```text
Name           ResourceGroup        Location    NumSubnets    Prefixes      DnsServers    DDOSProtection    VMProtection
-------------  -------------------  ----------  ------------  ------------  ------------  ----------------  --------------
intg-vnet-eus  rg-test-arck-rg-eus  eastus      2             10.21.0.0/16                False
```

You can list the subnet like this:

```bash
az network vnet subnet list --vnet-name intg-vnet-eus --resource-group rg-test-arck-rg-eus --output table
```

You will get this table back:

```text
AddressPrefix    Name                   PrivateEndpointNetworkPolicies    PrivateLinkServiceNetworkPolicies    ProvisioningState    ResourceGroup
---------------  ---------------------  --------------------------------  -----------------------------------  -------------------  -------------------
10.21.0.0/24     intg-appgw-sn01-eus    Disabled                          Enabled                              Succeeded            rg-test-arck-rg-eus
10.21.1.0/24     intg-backend-sn01-eus  Disabled                          Enabled                              Succeeded            rg-test-arck-rg-eus
```

#### Create a Public IP Address for the Application Gateway

Name of the public ip address: intg-appgw-pip-eus

```bash
az network public-ip create \
    --resource-group rg-test-arck-rg-eus \
    --name intg-appgw-pip-eus \
    --allocation-method Static \
    --sku Standard \
    --location eastus
```


you will get this json back:

```json
[Coming breaking change] In the coming release, the default behavior will be changed as follows when sku is Standard and zone is not provided: For zonal regions, you will get a zone-redundant IP indicated by zones:["1","2","3"]; For non-zonal regions, you will get a non zone-redundant IP indicated by zones:null.
{
  "publicIp": {
    "ddosSettings": {
      "protectionMode": "VirtualNetworkInherited"
    },
    "etag": "W/\"192de84b-0811-47d0-9e68-b86940ea6aad\"",
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/publicIPAddresses/intg-appgw-pip-eus",
    "idleTimeoutInMinutes": 4,
    "ipAddress": "13.82.234.233",
    "ipTags": [],
    "location": "eastus",
    "name": "intg-appgw-pip-eus",
    "provisioningState": "Succeeded",
    "publicIPAddressVersion": "IPv4",
    "publicIPAllocationMethod": "Static",
    "resourceGroup": "rg-test-arck-rg-eus",
    "resourceGuid": "d3fe53f4-22dc-47d9-8bce-5bc675d9b786",
    "sku": {
      "name": "Standard",
      "tier": "Regional"
    },
    "type": "Microsoft.Network/publicIPAddresses"
  }
}
```

Note: I decide to ignore the warning about the coming breaking change as adding zones can incure extra cost.

you can list the public ip address like this:

```bash
az network public-ip list --resource-group rg-test-arck-rg-euw --output table
```

The IP address is: 13.82.234.233

#### Create two virtual machines

copy the cloud-init.txt and run the command below to create the virtual machines.

```bash
for i in `seq 1 2`; do
  az network nic create \
    --resource-group rg-test-arck-rg-eus \
    --name intg-nic$i-eus \
    --vnet-name intg-vnet-eus \
    --subnet intg-backend-sn01-eus

  az vm create \
    --resource-group rg-test-arck-rg-eus \
    --name intg-vm$i-eus \
    --nics intg-nic$i-eus \
    --image Ubuntu2204 \
    --admin-username azureuser \
    --generate-ssh-keys \
    --custom-data cloud-init.txt \
    --location eastus
done
```

The json output is:
  
```json
{
  "NewNIC": {
    "auxiliaryMode": "None",
    "auxiliarySku": "None",
    "disableTcpStateTracking": false,
    "dnsSettings": {
      "appliedDnsServers": [],
      "dnsServers": [],
      "internalDomainNameSuffix": "eal0sith25cedg2h3ninucp3mg.bx.internal.cloudapp.net"
    },
    "enableAcceleratedNetworking": false,
    "enableIPForwarding": false,
    "etag": "W/\"4f982f66-8918-4f19-ba46-0c3cf4725818\"",
    "hostedWorkloads": [],
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/networkInterfaces/intg-nic1-eus",
    "ipConfigurations": [
      {
        "etag": "W/\"4f982f66-8918-4f19-ba46-0c3cf4725818\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/networkInterfaces/intg-nic1-eus/ipConfigurations/ipconfig1",
        "name": "ipconfig1",
        "primary": true,
        "privateIPAddress": "10.21.1.4",
        "privateIPAddressVersion": "IPv4",
        "privateIPAllocationMethod": "Dynamic",
        "provisioningState": "Succeeded",
        "resourceGroup": "rg-test-arck-rg-eus",
        "subnet": {
          "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/intg-vnet-eus/subnets/intg-backend-sn01-eus",
          "resourceGroup": "rg-test-arck-rg-eus"
        },
        "type": "Microsoft.Network/networkInterfaces/ipConfigurations"
      }
    ],
    "location": "eastus",
    "name": "intg-nic1-eus",
    "nicType": "Standard",
    "provisioningState": "Succeeded",
    "resourceGroup": "rg-test-arck-rg-eus",
    "resourceGuid": "f9adda01-4eaf-4374-a01a-b9db6137ca55",
    "tapConfigurations": [],
    "type": "Microsoft.Network/networkInterfaces",
    "vnetEncryptionSupported": false
  }
}
{
  "fqdns": "",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Compute/virtualMachines/intg-vm1-eus",
  "location": "eastus",
  "macAddress": "00-0D-3A-4E-EC-46",
  "powerState": "VM running",
  "privateIpAddress": "10.21.1.4",
  "publicIpAddress": "",
  "resourceGroup": "rg-test-arck-rg-eus",
  "zones": ""
}
{
  "NewNIC": {
    "auxiliaryMode": "None",
    "auxiliarySku": "None",
    "disableTcpStateTracking": false,
    "dnsSettings": {
      "appliedDnsServers": [],
      "dnsServers": [],
      "internalDomainNameSuffix": "eal0sith25cedg2h3ninucp3mg.bx.internal.cloudapp.net"
    },
    "enableAcceleratedNetworking": false,
    "enableIPForwarding": false,
    "etag": "W/\"91876682-8fd1-4ae7-8e9a-b9cf4f4eab1e\"",
    "hostedWorkloads": [],
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/networkInterfaces/intg-nic2-eus",
    "ipConfigurations": [
      {
        "etag": "W/\"91876682-8fd1-4ae7-8e9a-b9cf4f4eab1e\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/networkInterfaces/intg-nic2-eus/ipConfigurations/ipconfig1",
        "name": "ipconfig1",
        "primary": true,
        "privateIPAddress": "10.21.1.5",
        "privateIPAddressVersion": "IPv4",
        "privateIPAllocationMethod": "Dynamic",
        "provisioningState": "Succeeded",
        "resourceGroup": "rg-test-arck-rg-eus",
        "subnet": {
          "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/intg-vnet-eus/subnets/intg-backend-sn01-eus",
          "resourceGroup": "rg-test-arck-rg-eus"
        },
        "type": "Microsoft.Network/networkInterfaces/ipConfigurations"
      }
    ],
    "location": "eastus",
    "name": "intg-nic2-eus",
    "nicType": "Standard",
    "provisioningState": "Succeeded",
    "resourceGroup": "rg-test-arck-rg-eus",
    "resourceGuid": "02730bcf-20fe-45d6-93a2-c97ae952df2a",
    "tapConfigurations": [],
    "type": "Microsoft.Network/networkInterfaces",
    "vnetEncryptionSupported": false
  }
}
{
  "fqdns": "",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Compute/virtualMachines/intg-vm2-eus",
  "location": "eastus",
  "macAddress": "60-45-BD-EE-D9-E3",
  "powerState": "VM running",
  "privateIpAddress": "10.21.1.5",
  "publicIpAddress": "",
  "resourceGroup": "rg-test-arck-rg-eus",
  "zones": ""
}
```



#### Create the Application Gateway

Name of the application gateway: intg-appgw-eus

```bash
address1=$(az network nic show --name intg-nic1-eus --resource-group rg-test-arck-rg-eus | grep "\"privateIPAddress\":" | grep -oE '[^ ]+$' | tr -d '",')
echo $address1
address2=$(az network nic show --name intg-nic2-eus --resource-group rg-test-arck-rg-eus | grep "\"privateIPAddress\":" | grep -oE '[^ ]+$' | tr -d '",')
echo $address2


az network application-gateway create \
    --name intg-appgw-eus \
    --location eastus \
    --resource-group rg-test-arck-rg-eus \
    --capacity 2 \
    --sku Standard_v2 \
    --public-ip-address intg-appgw-pip-eus \
    --vnet-name intg-vnet-eus \
    --subnet intg-appgw-sn01-eus \
    --servers "$address1" "$address2" \
    --priority 100
```

NB! It can take up to 30 minutes for Azure to create the application gateway.

You should get a json back with the details of the application gateway.

```json
{
  "applicationGateway": {
    "backendAddressPools": [
      {
        "etag": "W/\"90081ccc-120b-43e5-8b6d-72ff5b428312\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendAddressPools/appGatewayBackendPool",
        "name": "appGatewayBackendPool",
        "properties": {
          "backendAddresses": [
            {
              "ipAddress": "10.21.1.4"
            },
            {
              "ipAddress": "10.21.1.5"
            }
          ],
          "provisioningState": "Succeeded",
          "requestRoutingRules": [
            {
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/requestRoutingRules/rule1",
              "resourceGroup": "rg-test-arck-rg-eus"
            }
          ]
        },
        "resourceGroup": "rg-test-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/backendAddressPools"
      }
    ],
    "backendHttpSettingsCollection": [
      {
        "etag": "W/\"90081ccc-120b-43e5-8b6d-72ff5b428312\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
        "name": "appGatewayBackendHttpSettings",
        "properties": {
          "connectionDraining": {
            "drainTimeoutInSec": 1,
            "enabled": false
          },
          "cookieBasedAffinity": "Disabled",
          "pickHostNameFromBackendAddress": false,
          "port": 80,
          "protocol": "Http",
          "provisioningState": "Succeeded",
          "requestRoutingRules": [
            {
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/requestRoutingRules/rule1",
              "resourceGroup": "rg-test-arck-rg-eus"
            }
          ],
          "requestTimeout": 30
        },
        "resourceGroup": "rg-test-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/backendHttpSettingsCollection"
      }
    ],
    "backendSettingsCollection": [],
    "frontendIPConfigurations": [
      {
        "etag": "W/\"90081ccc-120b-43e5-8b6d-72ff5b428312\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
        "name": "appGatewayFrontendIP",
        "properties": {
          "httpListeners": [
            {
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/httpListeners/appGatewayHttpListener",
              "resourceGroup": "rg-test-arck-rg-eus"
            }
          ],
          "privateIPAllocationMethod": "Dynamic",
          "provisioningState": "Succeeded",
          "publicIPAddress": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/publicIPAddresses/intg-appgw-pip-eus",
            "resourceGroup": "rg-test-arck-rg-eus"
          }
        },
        "resourceGroup": "rg-test-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/frontendIPConfigurations"
      }
    ],
    "frontendPorts": [
      {
        "etag": "W/\"90081ccc-120b-43e5-8b6d-72ff5b428312\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendPorts/appGatewayFrontendPort",
        "name": "appGatewayFrontendPort",
        "properties": {
          "httpListeners": [
            {
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/httpListeners/appGatewayHttpListener",
              "resourceGroup": "rg-test-arck-rg-eus"
            }
          ],
          "port": 80,
          "provisioningState": "Succeeded"
        },
        "resourceGroup": "rg-test-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/frontendPorts"
      }
    ],
    "gatewayIPConfigurations": [
      {
        "etag": "W/\"90081ccc-120b-43e5-8b6d-72ff5b428312\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/gatewayIPConfigurations/appGatewayFrontendIP",
        "name": "appGatewayFrontendIP",
        "properties": {
          "provisioningState": "Succeeded",
          "subnet": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/intg-vnet-eus/subnets/intg-appgw-sn01-eus",
            "resourceGroup": "rg-test-arck-rg-eus"
          }
        },
        "resourceGroup": "rg-test-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/gatewayIPConfigurations"
      }
    ],
    "httpListeners": [
      {
        "etag": "W/\"90081ccc-120b-43e5-8b6d-72ff5b428312\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/httpListeners/appGatewayHttpListener",
        "name": "appGatewayHttpListener",
        "properties": {
          "frontendIPConfiguration": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
            "resourceGroup": "rg-test-arck-rg-eus"
          },
          "frontendPort": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendPorts/appGatewayFrontendPort",
            "resourceGroup": "rg-test-arck-rg-eus"
          },
          "hostNames": [],
          "protocol": "Http",
          "provisioningState": "Succeeded",
          "requestRoutingRules": [
            {
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/requestRoutingRules/rule1",
              "resourceGroup": "rg-test-arck-rg-eus"
            }
          ],
          "requireServerNameIndication": false
        },
        "resourceGroup": "rg-test-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/httpListeners"
      }
    ],
    "listeners": [],
    "loadDistributionPolicies": [],
    "operationalState": "Running",
    "privateEndpointConnections": [],
    "privateLinkConfigurations": [],
    "probes": [],
    "provisioningState": "Succeeded",
    "redirectConfigurations": [],
    "requestRoutingRules": [
      {
        "etag": "W/\"90081ccc-120b-43e5-8b6d-72ff5b428312\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/requestRoutingRules/rule1",
        "name": "rule1",
        "properties": {
          "backendAddressPool": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendAddressPools/appGatewayBackendPool",
            "resourceGroup": "rg-test-arck-rg-eus"
          },
          "backendHttpSettings": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
            "resourceGroup": "rg-test-arck-rg-eus"
          },
          "httpListener": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/httpListeners/appGatewayHttpListener",
            "resourceGroup": "rg-test-arck-rg-eus"
          },
          "priority": 100,
          "provisioningState": "Succeeded",
          "ruleType": "Basic"
        },
        "resourceGroup": "rg-test-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/requestRoutingRules"
      }
    ],
    "resourceGuid": "6842116c-7766-45c8-aa61-7e7f0241d51f",
    "rewriteRuleSets": [],
    "routingRules": [],
    "sku": {
      "capacity": 2,
      "family": "Generation_1",
      "name": "Standard_v2",
      "tier": "Standard_v2"
    },
    "sslCertificates": [],
    "sslProfiles": [],
    "trustedClientCertificates": [],
    "trustedRootCertificates": [],
    "urlPathMaps": []
  }
}
```

#### Test the Application Gateway

We can check that the application gateway is working by going to the public IP address in a browser.
First we need know the public IP address of the application gateway.

```bash
az network public-ip show --resource-group rg-test-arck-rg-eus --name intg-appgw-pip-eus --query ipAddress --output tsv
```

Output is:

```text
13.82.234.233
```

Open this url in a browser: http://13.82.234.233
And you should see: Hello World from host intg-vm1-eus!


#### Assigning a custom domain to the Application Gateway

I use fastname to admin the domain name. I add an wildchar A record for the domain (*.arezibo.no) to point to the IP address 13.82.234.233.

Testing that the DNS is working

```bash
ping jalla.arezibo.no
PING jalla.arezibo.no (13.82.234.233): 56 data bytes
64 bytes from 13.82.234.233: icmp_seq=0 ttl=108 time=114.916 ms
```

Open this url in a browser: http://jalla.arezibo.no
And you should see: Hello World from host intg-vm1-eus!

#### a SSL certificate is needed and we use Let's Encrypt

This task if you dont have a SSL certificate for the domain arezibo.no.
Se the file 3ssl-create.md for detail output of the commands below.

NB! as you see i use password JALLA! this is ofcourse not the pw i used.

```bash
brew install certbot
```

Now we can create the certificate using the DNS challenge. We want the certificate for all of the subdomains of arezibo.no.

```bash
certbot certonly --manual --preferred-challenges=dns --email terje@arezibo.no -d "*.arezibo.no" -d arezibo.no
```

Convert the Certificate to PFX Format

```bash
cd secrets

openssl pkcs12 -export -out arezibo.no.pfx -inkey letsencrypt/live/arezibo.no/privkey.pem -in letsencrypt/live/arezibo.no/fullchain.pem -passout pass:JALLA!
```

check that you have the file:

```bash
ls -l arezibo.no.pfx
```

You should get this output:

```text
-rw-------  1 terchris  staff  3088 Mar 15 18:17 arezibo.no.pfx
```


#### Upload the Certificate to Azure Application Gateway

Change to the directory where the pfx file is located.

```bash
az network application-gateway ssl-cert create \
    --gateway-name intg-appgw-eus \
    --resource-group rg-test-arck-rg-eus \
    --name areziboSSLCert \
    --cert-file arezibo.no.pfx \
    --cert-password Vestengkleiva3!
```

You will get a json like this:
  
```json
{
  "etag": "W/\"70398e90-6490-44f8-ae4c-459df5164f60\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/sslCertificates/areziboSSLCert",
  "name": "areziboSSLCert",
  "provisioningState": "Succeeded",
  "publicCertData": "MIIJbwYJKoZIhvcNAQcCoIIJYDCCCVwCAQExADALBgkqhkiG9w0BBwGggglEMIIEJjCCAw6gAwIBAgISBG+e1mQjyhz0F/
  ...more base64 data....
  AA==",
  "resourceGroup": "rg-test-arck-rg-eus",
  "type": "Microsoft.Network/applicationGateways/sslCertificates"
}
```

#### Create the Frontend Port

Before you create the HTTPS listener, you need to create the frontend port.

```bash
az network application-gateway frontend-port create \
    --resource-group rg-test-arck-rg-eus \
    --gateway-name intg-appgw-eus \
    --name appGatewayFrontendPort443 \
    --port 443
```

You will get this json back:

```json
{
  "etag": "W/\"433909ca-40a0-4f13-9979-a3116568b65f\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendPorts/appGatewayFrontendPort443",
  "name": "appGatewayFrontendPort443",
  "port": 443,
  "provisioningState": "Succeeded",
  "resourceGroup": "rg-test-arck-rg-eus",
  "type": "Microsoft.Network/applicationGateways/frontendPorts"
}
```  


#### Create an HTTPS Listener
  
```bash
az network application-gateway http-listener create \
    --resource-group rg-test-arck-rg-eus \
    --gateway-name intg-appgw-eus \
    --name areziboHttpsListener \
    --frontend-port appGatewayFrontendPort443 \
    --ssl-cert areziboSSLCert
```

You will get this json back:

```json
{
  "etag": "W/\"2783853f-73b0-4e8b-abf4-f4a39f8e0cf0\"",
  "frontendIPConfiguration": {
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
    "resourceGroup": "rg-test-arck-rg-eus"
  },
  "frontendPort": {
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendPorts/appGatewayFrontendPort443",
    "resourceGroup": "rg-test-arck-rg-eus"
  },
  "hostNames": [],
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/httpListeners/areziboHttpsListener",
  "name": "areziboHttpsListener",
  "protocol": "Https",
  "provisioningState": "Succeeded",
  "requireServerNameIndication": false,
  "resourceGroup": "rg-test-arck-rg-eus",
  "sslCertificate": {
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/sslCertificates/areziboSSLCert",
    "resourceGroup": "rg-test-arck-rg-eus"
  },
  "type": "Microsoft.Network/applicationGateways/httpListeners"
}
```

Verify that the HTTPS listener is created.

```bash
az network application-gateway http-listener list \
    --resource-group rg-test-arck-rg-eus \
    --gateway-name intg-appgw-eus \
    --output table
```

You will get this table back:

```text
Name                    Protocol    ProvisioningState    RequireServerNameIndication    ResourceGroup
----------------------  ----------  -------------------  -----------------------------  -------------------
appGatewayHttpListener  Http        Succeeded            False                          rg-test-arck-rg-eus
areziboHttpsListener    Https       Succeeded            False                          rg-test-arck-rg-eus
```

Get the config of the application gateway

```bash
az network application-gateway show --name intg-appgw-eus --resource-group rg-test-arck-rg-eus
```

We need to add a rule so that all SSL requets are routed the same way as hhtp requests.

the rule is named httpsRule

```bash
az network application-gateway rule create \
    --resource-group rg-test-arck-rg-eus \
    --gateway-name intg-appgw-eus \
    --name httpsRule \
    --http-listener areziboHttpsListener \
    --rule-type Basic \
    --http-settings appGatewayBackendHttpSettings \
    --address-pool appGatewayBackendPool \
    --priority 101

```

You will get this json back:

```json
{
  "backendAddressPools": [
    {
      "backendAddresses": [
        {
          "ipAddress": "10.21.1.4"
        },
        {
          "ipAddress": "10.21.1.5"
        }
      ],
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendAddressPools/appGatewayBackendPool",
      "name": "appGatewayBackendPool",
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-test-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/backendAddressPools"
    }
  ],
  "backendHttpSettingsCollection": [
    {
      "connectionDraining": {
        "drainTimeoutInSec": 1,
        "enabled": false
      },
      "cookieBasedAffinity": "Disabled",
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
      "name": "appGatewayBackendHttpSettings",
      "pickHostNameFromBackendAddress": false,
      "port": 80,
      "protocol": "Http",
      "provisioningState": "Succeeded",
      "requestTimeout": 30,
      "resourceGroup": "rg-test-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/backendHttpSettingsCollection"
    }
  ],
  "backendSettingsCollection": [],
  "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
  "frontendIPConfigurations": [
    {
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
      "name": "appGatewayFrontendIP",
      "privateIPAllocationMethod": "Dynamic",
      "provisioningState": "Succeeded",
      "publicIPAddress": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/publicIPAddresses/intg-appgw-pip-eus",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "resourceGroup": "rg-test-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/frontendIPConfigurations"
    }
  ],
  "frontendPorts": [
    {
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendPorts/appGatewayFrontendPort",
      "name": "appGatewayFrontendPort",
      "port": 80,
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-test-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/frontendPorts"
    },
    {
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendPorts/appGatewayFrontendPort443",
      "name": "appGatewayFrontendPort443",
      "port": 443,
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-test-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/frontendPorts"
    }
  ],
  "gatewayIPConfigurations": [
    {
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/gatewayIPConfigurations/appGatewayFrontendIP",
      "name": "appGatewayFrontendIP",
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-test-arck-rg-eus",
      "subnet": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/intg-vnet-eus/subnets/intg-appgw-sn01-eus",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "type": "Microsoft.Network/applicationGateways/gatewayIPConfigurations"
    }
  ],
  "httpListeners": [
    {
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "frontendIPConfiguration": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "frontendPort": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendPorts/appGatewayFrontendPort",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "hostNames": [],
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/httpListeners/appGatewayHttpListener",
      "name": "appGatewayHttpListener",
      "protocol": "Http",
      "provisioningState": "Succeeded",
      "requireServerNameIndication": false,
      "resourceGroup": "rg-test-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/httpListeners"
    },
    {
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "frontendIPConfiguration": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "frontendPort": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/frontendPorts/appGatewayFrontendPort443",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "hostNames": [],
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/httpListeners/areziboHttpsListener",
      "name": "areziboHttpsListener",
      "protocol": "Https",
      "provisioningState": "Succeeded",
      "requireServerNameIndication": false,
      "resourceGroup": "rg-test-arck-rg-eus",
      "sslCertificate": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/sslCertificates/areziboSSLCert",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "type": "Microsoft.Network/applicationGateways/httpListeners"
    }
  ],
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus",
  "listeners": [],
  "loadDistributionPolicies": [],
  "location": "eastus",
  "name": "intg-appgw-eus",
  "operationalState": "Running",
  "privateEndpointConnections": [],
  "privateLinkConfigurations": [],
  "probes": [],
  "provisioningState": "Succeeded",
  "redirectConfigurations": [],
  "requestRoutingRules": [
    {
      "backendAddressPool": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendAddressPools/appGatewayBackendPool",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "backendHttpSettings": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "httpListener": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/httpListeners/appGatewayHttpListener",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/requestRoutingRules/rule1",
      "name": "rule1",
      "priority": 100,
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-test-arck-rg-eus",
      "ruleType": "Basic",
      "type": "Microsoft.Network/applicationGateways/requestRoutingRules"
    },
    {
      "backendAddressPool": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendAddressPools/appGatewayBackendPool",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "backendHttpSettings": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "httpListener": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/httpListeners/areziboHttpsListener",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/requestRoutingRules/httpsRule",
      "name": "httpsRule",
      "priority": 101,
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-test-arck-rg-eus",
      "ruleType": "Basic",
      "type": "Microsoft.Network/applicationGateways/requestRoutingRules"
    }
  ],
  "resourceGroup": "rg-test-arck-rg-eus",
  "resourceGuid": "6842116c-7766-45c8-aa61-7e7f0241d51f",
  "rewriteRuleSets": [],
  "routingRules": [],
  "sku": {
    "capacity": 2,
    "name": "Standard_v2",
    "tier": "Standard_v2"
  },
  "sslCertificates": [
    {
      "etag": "W/\"59ca901d-2e8c-47c1-9875-a852c2e45d16\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Network/applicationGateways/intg-appgw-eus/sslCertificates/areziboSSLCert",
      "name": "areziboSSLCert",
      "provisioningState": "Succeeded",
      "publicCertData": "MIIJbwYJKoZIhvcNAQcCoIIJYDCCCVwCAQExADALBgkqhkiG9w0BBwGggglEMIIEJjCCAw6gAwIBAgISBG+e1mQjyhz0F/
      ...more base64 data....
      AVRj+6Ulk1E7Kl5y0W8BzqKu4R8IxAA==",
      "resourceGroup": "rg-test-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/sslCertificates"
    }
  ],
  "sslProfiles": [],
  "tags": {},
  "trustedClientCertificates": [],
  "trustedRootCertificates": [],
  "type": "Microsoft.Network/applicationGateways",
  "urlPathMaps": []
}
```

Verify that we can use https request by opening this url in a browser: https://jalla.arezibo.no
And you should see: Hello World from host intg-vm1-eus!

Check if we have the WAF v2 SKU
  
```bash
  az network application-gateway show --name intg-appgw-eus --resource-group rg-test-arck-rg-eus --query "sku"
```

You will get this json back:

```json
{
  "capacity": 2,
  "name": "Standard_v2",
  "tier": "Standard_v2"
}
```


### Set up Azure functions

In order to test APIM we need to have some functions to call.


#### CAF naming convention for function apps

Functions need to be named in a CAF compliant way:

```text
func: Indicates the resource is a Function App.
intg: Denotes the integration landing zone.
testfunction: Specifies the name of the function app.
int001: The unique IntegrationID from in our tracking system.
eus: The region abbreviation for East US.
01: a two char hex to make the name unique. An instance or sequence number for versioning or multiple instances.
```

So the name of the function app is: func-intg-testfunction-int001-eus-01

#### CAF naming convention for storage accounts

Azure Storage account names must be between 3 and 24 characters in length and can contain only lowercase letters and numbers. And it must be unique across all of Azure.

```text
st: 2 char that denotes it's a storage account.
intg: 4 char that indicate landing zone.  Indicates it's part of the integration landing zone.
testfn: 6 char for the name 
int001: 6 char Integration ID 
eus: 3 char that Specifies the Azure region (East US) for the storage account.
01: a two char hex to make the name unique.
```

The above rule will use the maximum length of 24 characters.

Functions have separate storage accounts so that different teams do not interfere with each other. This is a best practice for isolation and security.
TODO: check the costs of this.

#### Create a storage account for the functions

The storage account for our test function is named:
stintgtestfnint001eus01

```bash
az storage account create \
    --name stintgtestfnint001eus01 \
    --resource-group rg-test-arck-rg-eus \
    --location eastus \
    --sku Standard_LRS \
    --kind StorageV2
```

You will get json like this:

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
  "creationTime": "2024-03-17T08:34:27.509650+00:00",
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
        "lastEnabledTime": "2024-03-17T08:34:27.759622+00:00"
      },
      "file": {
        "enabled": true,
        "keyType": "Account",
        "lastEnabledTime": "2024-03-17T08:34:27.759622+00:00"
      },
      "queue": null,
      "table": null
    }
  },
  "extendedLocation": null,
  "failoverInProgress": null,
  "geoReplicationStats": null,
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Storage/storageAccounts/stintgtestfnint001eus01",
  "identity": null,
  "immutableStorageWithVersioning": null,
  "isHnsEnabled": null,
  "isLocalUserEnabled": null,
  "isSftpEnabled": null,
  "isSkuConversionBlocked": null,
  "keyCreationTime": {
    "key1": "2024-03-17T08:34:27.744000+00:00",
    "key2": "2024-03-17T08:34:27.744000+00:00"
  },
  "keyPolicy": null,
  "kind": "StorageV2",
  "largeFileSharesState": null,
  "lastGeoFailoverTime": null,
  "location": "eastus",
  "minimumTlsVersion": "TLS1_0",
  "name": "stintgtestfnint001eus01",
  "networkRuleSet": {
    "bypass": "AzureServices",
    "defaultAction": "Allow",
    "ipRules": [],
    "ipv6Rules": [],
    "resourceAccessRules": null,
    "virtualNetworkRules": []
  },
  "primaryEndpoints": {
    "blob": "https://stintgtestfnint001eus01.blob.core.windows.net/",
    "dfs": "https://stintgtestfnint001eus01.dfs.core.windows.net/",
    "file": "https://stintgtestfnint001eus01.file.core.windows.net/",
    "internetEndpoints": null,
    "microsoftEndpoints": null,
    "queue": "https://stintgtestfnint001eus01.queue.core.windows.net/",
    "table": "https://stintgtestfnint001eus01.table.core.windows.net/",
    "web": "https://stintgtestfnint001eus01.z13.web.core.windows.net/"
  },
  "primaryLocation": "eastus",
  "privateEndpointConnections": [],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "rg-test-arck-rg-eus",
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
```

#### Create a function app

We will now create a function app with the name func-intg-testfunction-int001-eus-01. The storage account is named stintgtestfnint001eus01

```bash
az functionapp create \
  --resource-group rg-test-arck-rg-eus \
  --consumption-plan-location eastus \
  --runtime node \
  --functions-version 4 \
  --name func-intg-testfunction-int001-eus-01 \
  --storage-account stintgtestfnint001eus01
```

You will get this output:
  
```json
Application Insights "func-intg-testfunction-int001-eus-01" was created for this Function App. You can visit https://portal.azure.com/#resource/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/microsoft.insights/components/func-intg-testfunction-int001-eus-01/overview to view your Application Insights component
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
  "defaultHostName": "func-intg-testfunction-int001-eus-01.azurewebsites.net",
  "enabled": true,
  "enabledHostNames": [
    "func-intg-testfunction-int001-eus-01.azurewebsites.net",
    "func-intg-testfunction-int001-eus-01.scm.azurewebsites.net"
  ],
  "extendedLocation": null,
  "hostNameSslStates": [
    {
      "certificateResourceId": null,
      "hostType": "Standard",
      "ipBasedSslResult": null,
      "ipBasedSslState": "NotConfigured",
      "name": "func-intg-testfunction-int001-eus-01.azurewebsites.net",
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
      "name": "func-intg-testfunction-int001-eus-01.scm.azurewebsites.net",
      "sslState": "Disabled",
      "thumbprint": null,
      "toUpdate": null,
      "toUpdateIpBasedSsl": null,
      "virtualIPv6": null,
      "virtualIp": null
    }
  ],
  "hostNames": [
    "func-intg-testfunction-int001-eus-01.azurewebsites.net"
  ],
  "hostNamesDisabled": false,
  "hostingEnvironmentProfile": null,
  "httpsOnly": false,
  "hyperV": false,
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Web/sites/func-intg-testfunction-int001-eus-01",
  "identity": null,
  "inProgressOperationId": null,
  "isDefaultContainer": null,
  "isXenon": false,
  "keyVaultReferenceIdentity": "SystemAssigned",
  "kind": "functionapp",
  "lastModifiedTimeUtc": "2024-03-17T10:52:33.960000",
  "location": "eastus",
  "managedEnvironmentId": null,
  "maxNumberOfWorkers": null,
  "name": "func-intg-testfunction-int001-eus-01",
  "outboundIpAddresses": "20.85.255.82,20.85.255.93,20.85.255.102,20.85.255.108,20.85.255.159,20.85.252.169,20.119.0.2",
  "possibleOutboundIpAddresses": "20.85.255.82,20.85.255.93,20.85.255.102,20.85.255.108,20.85.255.159,20.85.252.169,20.85.255.164,20.85.255.180,20.85.255.183,20.85.254.29,20.85.255.220,20.85.255.225,20.85.255.228,20.85.255.230,20.121.96.35,20.85.248.204,20.85.249.203,20.85.254.113,20.84.12.134,20.85.250.10,20.85.250.11,20.85.250.20,20.85.250.21,20.85.253.84,20.85.250.24,20.85.250.104,20.85.250.137,20.85.250.142,20.85.250.179,20.85.255.130,20.119.0.2",
  "publicNetworkAccess": null,
  "redundancyMode": "None",
  "repositorySiteName": "func-intg-testfunction-int001-eus-01",
  "reserved": false,
  "resourceConfig": null,
  "resourceGroup": "rg-test-arck-rg-eus",
  "scmSiteAlsoStopped": false,
  "serverFarmId": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Web/serverfarms/EastUSPlan",
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


You can list the function apps with this command:

```bash
az functionapp list --resource-group rg-test-arck-rg-eus --output table
```

You will get this output:

```text
Name                                  Location    State    ResourceGroup        DefaultHostName                                         AppServicePlan
------------------------------------  ----------  -------  -------------------  ------------------------------------------------------  ----------------
func-intg-testfunction-int001-eus-01  East US     Running  rg-test-arck-rg-eus  func-intg-testfunction-int001-eus-01.azurewebsites.net  EastUSPlan
```

If you need to delete the function app you can do it with this command:

```bash
az functionapp delete --name func-intg-testfunction-int001-eus-01 --resource-group rg-test-arck-rg-eus
```

#### Creating two test functions

In oder to test APIM we need to have api functions we can call.
The folder TestFunction contains two functions:

- TimeFunction - returns the current time
- DayOfWeekFunction - returns the current day of the week

See readme.md file in the folder for more information about the functions.
Their internal workings, and how to test them locally.
You dont need to mess with the code. But you ned to install the tools that enable you to use the func command.

The name of the function app is: func-intg-testfunction-int001-eus-01
To use the func tool you do:

```bash
cd TestFunction

func azure functionapp publish func-intg-testfunction-int001-eus-01
```

The output will be:

```text
Setting Functions site property 'netFrameworkVersion' to 'v6.0'
Getting site publishing info...
[2024-03-17T11:22:53.850Z] Starting the function app deployment...
Creating archive for current directory...
Uploading 644.02 KB [#############################################################################]
Upload completed successfully.
Deployment completed successfully.
[2024-03-17T11:23:16.543Z] Syncing triggers...
Functions in func-intg-testfunction-int001-eus-01:
    DayOfWeekFunction - [httpTrigger]
        Invoke url: https://func-intg-testfunction-int001-eus-01.azurewebsites.net/api/dayofweekfunction

    TimeFunction - [httpTrigger]
        Invoke url: https://func-intg-testfunction-int001-eus-01.azurewebsites.net/api/timefunction
```

You can now test the functions by opening the urls in a browser.
As you see the functions are now available and open for everyone to use. No security at all.
Or you can use curl or postman to test them.

```bash
curl https://func-intg-testfunction-int001-eus-01.azurewebsites.net/api/timefunction
```

To get the configuration of the function app you can do:

```bash
az functionapp config appsettings list --name func-intg-testfunction-int001-eus-01 --resource-group rg-test-arck-rg-eus
```

You will get this output:

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
    "value": "DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=stintgtestfnint001eus01;AccountKey=grEpGiatjY9ZawuSi3ua87MJ44ZO41c8xtdeXZ910WLaQndi9SglvBWRFSkZymjXG9eCh9eY/6II+ASt7aYv9g=="
  },
  {
    "name": "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING",
    "slotSetting": false,
    "value": "DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=stintgtestfnint001eus01;AccountKey=grEpGiatjY9ZawuSi3ua87MJ44ZO41c8xtdeXZ910WLaQndi9SglvBWRFSkZymjXG9eCh9eY/6II+ASt7aYv9g=="
  },
  {
    "name": "WEBSITE_CONTENTSHARE",
    "slotSetting": false,
    "value": "func-intg-testfunction-int001-eus-013305757612fc"
  },
  {
    "name": "APPLICATIONINSIGHTS_CONNECTION_STRING",
    "slotSetting": false,
    "value": "InstrumentationKey=79fb7c62-b2b9-49f4-a41e-5f881ae964dd;IngestionEndpoint=https://eastus-8.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/"
  },
  {
    "name": "WEBSITE_RUN_FROM_PACKAGE",
    "slotSetting": false,
    "value": "1"
  }
]

```


### Create APIM

We create SKU Developer as it has the networking features we need.The upcomming Standard v2 SKU is not available in the az cli yet.

NB! It might take up to 30 minutes to create the APIM.

```bash
az apim create \
  --name intg-apim-eus \
  --resource-group rg-test-arck-rg-eus \
  --publisher-email "terchris.redcross@gmail.com" \
  --publisher-name "terchris" \
  --sku-name Developer \
  --location eastus

```

You get this json back:

```json
Resource provider 'Microsoft.ApiManagement' used by this operation is not registered. We are registering for you.
Registration succeeded.
{
  "additionalLocations": null,
  "apiVersionConstraint": {
    "minApiVersion": null
  },
  "certificates": null,
  "createdAtUtc": "2024-03-17T14:14:33.130338+00:00",
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
  "developerPortalUrl": "https://intg-apim-eus.developer.azure-api.net",
  "disableGateway": false,
  "enableClientCertificate": null,
  "etag": "AAAAAAD/iRI=",
  "gatewayRegionalUrl": "https://intg-apim-eus-eastus-01.regional.azure-api.net",
  "gatewayUrl": "https://intg-apim-eus.azure-api.net",
  "hostnameConfigurations": [
    {
      "certificate": null,
      "certificatePassword": null,
      "certificateSource": "BuiltIn",
      "certificateStatus": null,
      "defaultSslBinding": true,
      "encodedCertificate": null,
      "hostName": "intg-apim-eus.azure-api.net",
      "identityClientId": null,
      "keyVaultId": null,
      "negotiateClientCertificate": false,
      "type": "Proxy"
    }
  ],
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.ApiManagement/service/intg-apim-eus",
  "identity": null,
  "location": "East US",
  "managementApiUrl": "https://intg-apim-eus.management.azure-api.net",
  "name": "intg-apim-eus",
  "natGatewayState": "Disabled",
  "notificationSenderEmail": "terchris.redcross@gmail.com",
  "outboundPublicIpAddresses": [
    "172.214.64.183"
  ],
  "platformVersion": "stv2",
  "portalUrl": "https://intg-apim-eus.portal.azure-api.net",
  "privateEndpointConnections": null,
  "privateIpAddresses": null,
  "provisioningState": "Succeeded",
  "publicIpAddressId": null,
  "publicIpAddresses": [
    "172.214.64.183"
  ],
  "publicNetworkAccess": "Enabled",
  "publisherEmail": "terchris.redcross@gmail.com",
  "publisherName": "terchris",
  "resourceGroup": "rg-test-arck-rg-eus",
  "restore": null,
  "scmUrl": "https://intg-apim-eus.scm.azure-api.net",
  "sku": {
    "capacity": 1,
    "name": "Developer"
  },
  "systemData": {
    "createdAt": "2024-03-17T14:14:32.733488+00:00",
    "createdBy": "terchris.redcross@gmail.com",
    "createdByType": "User",
    "lastModifiedAt": "2024-03-17T14:14:32.733488+00:00",
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
Developer Portal URL: Access the portal for developers to learn and test your APIs. URL: https://intg-apim-eus.developer.azure-api.net
Gateway Regional URL: Endpoint for the regional API gateway, enhancing performance for regional users. URL: https://intg-apim-eus-eastus-01.regional.azure-api.net
Gateway URL: Main entry point for API calls to your APIM service. URL: https://intg-apim-eus.azure-api.net
Management API URL: Interface for programmatically managing your APIs. URL: https://intg-apim-eus.management.azure-api.net
Portal URL: Older version of the developer portal for API interaction. URL: https://intg-apim-eus.portal.azure-api.net
SCM URL: Used for deployment and source control management. URL: https://intg-apim-eus.scm.azure-api.net
```


List the APIMs to check if it was created and is running:

```bash
az apim list --query "[].{Name:name, Location:location, Sku:sku.name, PublisherEmail:publisherEmail}" -o table
```

The output will be:

```text
Name           Location    Sku        PublisherEmail
-------------  ----------  ---------  ---------------------------
intg-apim-eus  East US     Developer  terchris.redcross@gmail.com
```

### Add the the TestFunction to the APIM

We now need to add the functions to the APIM.
We are doing that using Bicep. See the file [4bicep-setup](./4bicep-setup.md) for more information on how to set it up.

The Bicep definition for setting up the two API's in TestFunction is in the file [testfunction-apis.bicep](./apim-bicep/testfunction-apis.bicep).

To deploy the bicep file you do:

```bash
az deployment group create --resource-group rg-test-arck-rg-eus --template-file ./apim-bicep/testfunction-apis.bicep
```

The output will be:

```json
{
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Resources/deployments/testfunction-apis",
  "location": null,
  "name": "testfunction-apis",
  "properties": {
    "correlationId": "877aec4d-eb9f-4513-b59d-6fbca7052ce7",
    "debugSetting": null,
    "dependencies": [],
    "duration": "PT4.457667S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.ApiManagement/service/intg-apim-eus/apis/dayofweekfunction",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.ApiManagement/service/intg-apim-eus/apis/timefunction",
        "resourceGroup": "rg-test-arck-rg-eus"
      }
    ],
    "outputs": null,
    "parameters": {
      "apimServiceName": {
        "type": "String",
        "value": "intg-apim-eus"
      },
      "basePath": {
        "type": "String",
        "value": "testfunction/v1"
      },
      "functionAppUrl": {
        "type": "String",
        "value": "https://func-intg-testfunction-int001-eus-01.azurewebsites.net"
      }
    },
    "parametersLink": null,
    "providers": [
      {
        "id": null,
        "namespace": "Microsoft.ApiManagement",
        "providerAuthorizationConsentState": null,
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              null
            ],
            "properties": null,
            "resourceType": "service/apis",
            "zoneMappings": null
          }
        ]
      }
    ],
    "provisioningState": "Succeeded",
    "templateHash": "9734179738324698116",
    "templateLink": null,
    "timestamp": "2024-03-17T15:45:45.493561+00:00",
    "validatedResources": null
  },
  "resourceGroup": "rg-test-arck-rg-eus",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
```

You can list the API's in the APIM with this command:

```bash
az apim api list --service-name intg-apim-eus --resource-group rg-test-arck-rg-eus --query "[].{name:name, path:path, serviceUrl:serviceUrl}" -o table
```

You will get this output:

```text
Name               Path                               ServiceUrl
-----------------  ---------------------------------  ------------------------------------------------------------------------------------
dayofweekfunction  testfunction/v1/dayofweekfunction  https://func-intg-testfunction-int001-eus-01.azurewebsites.net/api/dayofweekfunction
echo-api           echo                               http://echoapi.cloudapp.net/api
timefunction       testfunction/v1/timefunction       https://func-intg-testfunction-int001-eus-01.azurewebsites.net/api/timefunction
```

For each API, check the operation details:
  
```bash
az apim api show --resource-group rg-test-arck-rg-eus --service-name intg-apim-eus --api-id timefunction --query "{name:name, serviceUrl:serviceUrl, protocols:protocols}" -o tsv
```


az apim api show --resource-group rg-test-arck-rg-eus --service-name intg-apim-eus --api-id echo-api --query "{name:name, serviceUrl:serviceUrl, protocols:protocols}" -o tsv

You will get this output:

```text
timefunction	https://func-intg-testfunction-int001-eus-01.azurewebsites.net/api/timefunction	1
```  


Use the following command to inspect any policies applied to your timefunction API:
  
```bash
az apim api policy show --resource-group rg-test-arck-rg-eus --service-name intg-apim-eus --api-id timefunction
```

It is not possibble to access the URLs yet. We need to add anonumous access.
This is defined in the file [testfunction-allow-anonymous-access.bicep](./apim-bicep/testfunction-allow-anonymous-access.bicep).

To deploy the bicep file you do:

```bash
az deployment group create --resource-group rg-test-arck-rg-eus --template-file ./apim-bicep/testfunction-allow-anonymous-access.bicep
```

The json output will be:

```json
{
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.Resources/deployments/testfunction-allow-anonymous-access",
  "location": null,
  "name": "testfunction-allow-anonymous-access",
  "properties": {
    "correlationId": "5f133a04-c5ff-4e05-b69d-2b5984543f0c",
    "debugSetting": null,
    "dependencies": [],
    "duration": "PT5.6238698S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.ApiManagement/service/intg-apim-eus/apis/dayofweekfunction/policies/policy",
        "resourceGroup": "rg-test-arck-rg-eus"
      },
      {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-test-arck-rg-eus/providers/Microsoft.ApiManagement/service/intg-apim-eus/apis/timefunction/policies/policy",
        "resourceGroup": "rg-test-arck-rg-eus"
      }
    ],
    "outputs": null,
    "parameters": {
      "apimServiceName": {
        "type": "String",
        "value": "intg-apim-eus"
      },
      "dayOfWeekFunctionApiName": {
        "type": "String",
        "value": "dayofweekfunction"
      },
      "resourceGroupName": {
        "type": "String",
        "value": "rg-test-arck-rg-eus"
      },
      "timeFunctionApiName": {
        "type": "String",
        "value": "timefunction"
      }
    },
    "parametersLink": null,
    "providers": [
      {
        "id": null,
        "namespace": "Microsoft.ApiManagement",
        "providerAuthorizationConsentState": null,
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              null
            ],
            "properties": null,
            "resourceType": "service/apis/policies",
            "zoneMappings": null
          }
        ]
      }
    ],
    "provisioningState": "Succeeded",
    "templateHash": "12490606656577874869",
    "templateLink": null,
    "timestamp": "2024-03-17T16:34:12.098424+00:00",
    "validatedResources": null
  },
  "resourceGroup": "rg-test-arck-rg-eus",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
```

# debugging 

az apim api show --resource-group rg-test-arck-rg-eus --service-name intg-apim-eus --api-id timefunction --output json

az apim api operation list --resource-group rg-test-arck-rg-eus --service-name intg-apim-eus --api-id echo-api --output json


az apim api operation list --resource-group rg-test-arck-rg-eus --service-name intg-apim-eus --api-id timefunction --output json
