# cmd application gateway

## Application Gateway Configuration

All traffic to the landing zones will be routed through an Application Gateway. The Application Gateway will be configured to route traffic based on the subdomain.

### Public IP for Application Gateway

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

### 4.3 Create Application Gateway

Create the Application Gateway:

Could not use the --min-capacity 0  and --max-capacity 1 Had to set the capacity to 1.

```bash
az network application-gateway create \
    --name appgw-eus \
    --location eastus \
    --resource-group rg-terchris-arck-rg-eus \
    --vnet-name vnet-eus \
    --subnet appgw-backend-sn01-eus \
    --sku Standard_v2 \
    --http-settings-cookie-based-affinity Disabled \
    --frontend-port 80 \
    --http-settings-port 80 \
    --http-settings-protocol Http \
    --public-ip-address appgw-pip-eus \
    --capacity 1 \
    --priority 10    
```

Output is:

```json
{
  "applicationGateway": {
    "backendAddressPools": [
      {
        "etag": "W/\"cdcf95a4-a72d-4af2-8c52-ca9aab9a1ddb\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendAddressPools/appGatewayBackendPool",
        "name": "appGatewayBackendPool",
        "properties": {
          "backendAddresses": [],
          "provisioningState": "Succeeded",
          "requestRoutingRules": [
            {
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/requestRoutingRules/rule1",
              "resourceGroup": "rg-terchris-arck-rg-eus"
            }
          ]
        },
        "resourceGroup": "rg-terchris-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/backendAddressPools"
      }
    ],
    "backendHttpSettingsCollection": [
      {
        "etag": "W/\"cdcf95a4-a72d-4af2-8c52-ca9aab9a1ddb\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
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
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/requestRoutingRules/rule1",
              "resourceGroup": "rg-terchris-arck-rg-eus"
            }
          ],
          "requestTimeout": 30
        },
        "resourceGroup": "rg-terchris-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/backendHttpSettingsCollection"
      }
    ],
    "backendSettingsCollection": [],
    "frontendIPConfigurations": [
      {
        "etag": "W/\"cdcf95a4-a72d-4af2-8c52-ca9aab9a1ddb\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
        "name": "appGatewayFrontendIP",
        "properties": {
          "httpListeners": [
            {
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/appGatewayHttpListener",
              "resourceGroup": "rg-terchris-arck-rg-eus"
            }
          ],
          "privateIPAllocationMethod": "Dynamic",
          "provisioningState": "Succeeded",
          "publicIPAddress": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/publicIPAddresses/appgw-pip-eus",
            "resourceGroup": "rg-terchris-arck-rg-eus"
          }
        },
        "resourceGroup": "rg-terchris-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/frontendIPConfigurations"
      }
    ],
    "frontendPorts": [
      {
        "etag": "W/\"cdcf95a4-a72d-4af2-8c52-ca9aab9a1ddb\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayFrontendPort",
        "name": "appGatewayFrontendPort",
        "properties": {
          "httpListeners": [
            {
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/appGatewayHttpListener",
              "resourceGroup": "rg-terchris-arck-rg-eus"
            }
          ],
          "port": 80,
          "provisioningState": "Succeeded"
        },
        "resourceGroup": "rg-terchris-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/frontendPorts"
      }
    ],
    "gatewayIPConfigurations": [
      {
        "etag": "W/\"cdcf95a4-a72d-4af2-8c52-ca9aab9a1ddb\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/gatewayIPConfigurations/appGatewayFrontendIP",
        "name": "appGatewayFrontendIP",
        "properties": {
          "provisioningState": "Succeeded",
          "subnet": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/appgw-backend-sn01-eus",
            "resourceGroup": "rg-terchris-arck-rg-eus"
          }
        },
        "resourceGroup": "rg-terchris-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/gatewayIPConfigurations"
      }
    ],
    "httpListeners": [
      {
        "etag": "W/\"cdcf95a4-a72d-4af2-8c52-ca9aab9a1ddb\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/appGatewayHttpListener",
        "name": "appGatewayHttpListener",
        "properties": {
          "frontendIPConfiguration": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
            "resourceGroup": "rg-terchris-arck-rg-eus"
          },
          "frontendPort": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayFrontendPort",
            "resourceGroup": "rg-terchris-arck-rg-eus"
          },
          "hostNames": [],
          "protocol": "Http",
          "provisioningState": "Succeeded",
          "requestRoutingRules": [
            {
              "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/requestRoutingRules/rule1",
              "resourceGroup": "rg-terchris-arck-rg-eus"
            }
          ],
          "requireServerNameIndication": false
        },
        "resourceGroup": "rg-terchris-arck-rg-eus",
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
        "etag": "W/\"cdcf95a4-a72d-4af2-8c52-ca9aab9a1ddb\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/requestRoutingRules/rule1",
        "name": "rule1",
        "properties": {
          "backendAddressPool": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendAddressPools/appGatewayBackendPool",
            "resourceGroup": "rg-terchris-arck-rg-eus"
          },
          "backendHttpSettings": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
            "resourceGroup": "rg-terchris-arck-rg-eus"
          },
          "httpListener": {
            "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/appGatewayHttpListener",
            "resourceGroup": "rg-terchris-arck-rg-eus"
          },
          "priority": 10,
          "provisioningState": "Succeeded",
          "ruleType": "Basic"
        },
        "resourceGroup": "rg-terchris-arck-rg-eus",
        "type": "Microsoft.Network/applicationGateways/requestRoutingRules"
      }
    ],
    "resourceGuid": "efea21d0-e5ee-4caf-ae77-738a3bd7c848",
    "rewriteRuleSets": [],
    "routingRules": [],
    "sku": {
      "capacity": 1,
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
````

To verify the Application Gateway, you can use the following command:

```bash
az network application-gateway show --name appgw-eus --resource-group rg-terchris-arck-rg-eus
```
