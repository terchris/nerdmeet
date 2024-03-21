# cmd firewall config

## Firewall configuration

we are using an Application Gateway as a firewall. The Application Gateway is the only resource with a public IP address. The Application Gateway terminates SSL and routes traffic based on subdomain.

This file contains all commands to set up the rules and SSL for the Application Gateway. For overview see the [nerdnet firewall](9nerdnet-firewall.md) file.

### Upload SSL Certificate to Azure

Make sure you have the PFX file and the password for the PFX file.

```bash
az network application-gateway ssl-cert create \
    --gateway-name appgw-eus \
    --resource-group rg-terchris-arck-rg-eus \
    --name christensen-ssl-cert \
    --cert-file ../secrets/cert/christensen.no.pfx \
    --cert-password JALLA!
```

output is:

```json
{
  "etag": "W/\"eabc29d3-de5d-4104-b68b-75954417992a\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/sslCertificates/christensen-ssl-cert",
  "name": "christensen-ssl-cert",
  "provisioningState": "Succeeded",
  "publicCertData": "long base64 string",
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "type": "Microsoft.Network/applicationGateways/sslCertificates"
}
```


### Create https frontend port

```bash
az network application-gateway frontend-port create \
    --gateway-name appgw-eus \
    --resource-group rg-terchris-arck-rg-eus \
    --name appGatewayHttpsFrontendPort \
    --port 443
```

output is:

```json
{
  "etag": "W/\"45d88292-b84a-4d4e-a34b-db4c06b26909\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayHttpsFrontendPort",
  "name": "appGatewayHttpsFrontendPort",
  "port": 443,
  "provisioningState": "Succeeded",
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "type": "Microsoft.Network/applicationGateways/frontendPorts"
}
```

List the frontend ports:

```bash
az network application-gateway frontend-port list --gateway-name appgw-eus --resource-group rg-terchris-arck-rg-eus --output table
```

output is:

```text
Name                         Port    ProvisioningState    ResourceGroup
---------------------------  ------  -------------------  -----------------------
appGatewayFrontendPort       80      Succeeded            rg-terchris-arck-rg-eus
appGatewayHttpsFrontendPort  443     Succeeded            rg-terchris-arck-rg-eus
```


### Create pool (routing to landing zones)

Application Gateway needs a backend pool to route traffic to. This is done by creating a backend pool for each landing zone.
The pool can be just one IP or it can be a list of IPs.



#### VM in nerd Landing Zone

Get the private IP address of the NIC and store it in a variable:
I cant dind a az command that give me the IP address of a VM or its NIC. So we have to do some tricks.

```bash
NERDVM01_IP=$(az vm run-command invoke --command-id RunShellScript --name nerd-vm01-eus --resource-group rg-terchris-arck-rg-eus --scripts "hostname -I | awk '{print \$1}'") && echo $ip | awk '/\[stdout\]/{getline; print; exit}'


echo $NERDVM01_IP
```

helvete - vet at IP er 10.21.1.4

Use the NERDVM01_IP to create an address pool for the Application Gateway:
  
  ```bash
az network application-gateway address-pool create \
    --gateway-name appgw-eus \
    --resource-group rg-terchris-arck-rg-eus \
    --name vm1-nerd-ip-pool \
    --servers $NERDVM01_IP
```

output is:

```json
{
  "backendAddresses": [
    {
      "ipAddress": "10.21.1.4"
    }
  ],
  "etag": "W/\"965387fb-caa7-456e-ac06-4ca6ca4aa786\"",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendAddressPools/vm1-nerd-ip-pool",
  "name": "vm1-nerd-ip-pool",
  "provisioningState": "Succeeded",
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "type": "Microsoft.Network/applicationGateways/backendAddressPools"
}
```


### Create Listener's for the Application Gateway

#### Create Listener for vm1.christensen.no

There must be two listeneres. One for HTTP and one for HTTPS.

Create the HTTP listener for the subdomain vm1.christensen.no:

```bash
az network application-gateway http-listener create \
    --resource-group rg-terchris-arck-rg-eus \
    --name vm1-http-listener \
    --frontend-port appGatewayFrontendPort \
    --gateway-name appgw-eus \
    --frontend-ip appGatewayFrontendIP \
    --host-name "vm1.christensen.no"

```

output is:

```json
{
  "etag": "W/\"6e1dfa72-d149-4a62-a22d-5df0edeb5019\"",
  "frontendIPConfiguration": {
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
    "resourceGroup": "rg-terchris-arck-rg-eus"
  },
  "frontendPort": {
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayFrontendPort",
    "resourceGroup": "rg-terchris-arck-rg-eus"
  },
  "hostName": "vm1.christensen.no",
  "hostNames": [],
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/vm1-http-listener",
  "name": "vm1-http-listener",
  "protocol": "Http",
  "provisioningState": "Succeeded",
  "requireServerNameIndication": false,
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "type": "Microsoft.Network/applicationGateways/httpListeners"
}
```

Create the HTTPS listener for the subdomain vm1.christensen.no:

```bash
az network application-gateway http-listener create \
    --resource-group rg-terchris-arck-rg-eus \
    --name vm1-https-listener \
    --frontend-port appGatewayHttpsFrontendPort \
    --gateway-name appgw-eus \
    --frontend-ip appGatewayFrontendIP \
    --host-name "vm1.christensen.no" \
    --ssl-cert christensen-ssl-cert
```

output is:

```json
{
  "etag": "W/\"bd441d6d-99d6-447f-8b17-55bfaadb7b08\"",
  "frontendIPConfiguration": {
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
    "resourceGroup": "rg-terchris-arck-rg-eus"
  },
  "frontendPort": {
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayHttpsFrontendPort",
    "resourceGroup": "rg-terchris-arck-rg-eus"
  },
  "hostName": "vm1.christensen.no",
  "hostNames": [],
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/vm1-https-listener",
  "name": "vm1-https-listener",
  "protocol": "Https",
  "provisioningState": "Succeeded",
  "requireServerNameIndication": true,
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "sslCertificate": {
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/sslCertificates/christensen-ssl-cert",
    "resourceGroup": "rg-terchris-arck-rg-eus"
  },
  "type": "Microsoft.Network/applicationGateways/httpListeners"
}
```

### Create Rules for the Application Gateway

also here here are HTTP and HTTPS rules.

To list al rules in a table:

```bash
az network application-gateway rule list --gateway-name appgw-eus --resource-group rg-terchris-arck-rg-eus --output table
```

#### Create Rule for vm1.christensen.no

Create the HTTP rule for the subdomain vm1.christensen.no:

```bash
az network application-gateway rule create \
    --resource-group rg-terchris-arck-rg-eus \
    --gateway-name appgw-eus \
    --name rule-vm1-http \
    --http-listener vm1-http-listener \
    --rule-type Basic \
    --address-pool vm1-nerd-ip-pool \
    --priority 100

```

output is:

```json
{
  "backendAddressPools": [
    {
      "backendAddresses": [],
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendAddressPools/appGatewayBackendPool",
      "name": "appGatewayBackendPool",
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/backendAddressPools"
    },
    {
      "backendAddresses": [
        {
          "ipAddress": "10.21.1.4"
        }
      ],
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendAddressPools/vm1-nerd-ip-pool",
      "name": "vm1-nerd-ip-pool",
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-terchris-arck-rg-eus",
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
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
      "name": "appGatewayBackendHttpSettings",
      "pickHostNameFromBackendAddress": false,
      "port": 80,
      "protocol": "Http",
      "provisioningState": "Succeeded",
      "requestTimeout": 30,
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/backendHttpSettingsCollection"
    }
  ],
  "backendSettingsCollection": [],
  "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
  "frontendIPConfigurations": [
    {
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
      "name": "appGatewayFrontendIP",
      "privateIPAllocationMethod": "Dynamic",
      "provisioningState": "Succeeded",
      "publicIPAddress": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/publicIPAddresses/appgw-pip-eus",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/frontendIPConfigurations"
    }
  ],
  "frontendPorts": [
    {
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayFrontendPort",
      "name": "appGatewayFrontendPort",
      "port": 80,
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/frontendPorts"
    },
    {
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayHttpsFrontendPort",
      "name": "appGatewayHttpsFrontendPort",
      "port": 443,
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/frontendPorts"
    }
  ],
  "gatewayIPConfigurations": [
    {
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/gatewayIPConfigurations/appGatewayFrontendIP",
      "name": "appGatewayFrontendIP",
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "subnet": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/appgw-backend-sn01-eus",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "type": "Microsoft.Network/applicationGateways/gatewayIPConfigurations"
    }
  ],
  "httpListeners": [
    {
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "frontendIPConfiguration": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "frontendPort": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayFrontendPort",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "hostNames": [],
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/appGatewayHttpListener",
      "name": "appGatewayHttpListener",
      "protocol": "Http",
      "provisioningState": "Succeeded",
      "requireServerNameIndication": false,
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/httpListeners"
    },
    {
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "frontendIPConfiguration": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "frontendPort": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayFrontendPort",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "hostName": "vm1.christensen.no",
      "hostNames": [],
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/vm1-http-listener",
      "name": "vm1-http-listener",
      "protocol": "Http",
      "provisioningState": "Succeeded",
      "requireServerNameIndication": false,
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "type": "Microsoft.Network/applicationGateways/httpListeners"
    },
    {
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "frontendIPConfiguration": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendIPConfigurations/appGatewayFrontendIP",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "frontendPort": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/frontendPorts/appGatewayHttpsFrontendPort",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "hostName": "vm1.christensen.no",
      "hostNames": [],
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/vm1-https-listener",
      "name": "vm1-https-listener",
      "protocol": "Https",
      "provisioningState": "Succeeded",
      "requireServerNameIndication": true,
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "sslCertificate": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/sslCertificates/christensen-ssl-cert",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "type": "Microsoft.Network/applicationGateways/httpListeners"
    }
  ],
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus",
  "listeners": [],
  "loadDistributionPolicies": [],
  "location": "eastus",
  "name": "appgw-eus",
  "operationalState": "Running",
  "privateEndpointConnections": [],
  "privateLinkConfigurations": [],
  "probes": [],
  "provisioningState": "Succeeded",
  "redirectConfigurations": [],
  "requestRoutingRules": [
    {
      "backendAddressPool": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendAddressPools/appGatewayBackendPool",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "backendHttpSettings": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "httpListener": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/appGatewayHttpListener",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/requestRoutingRules/rule1",
      "name": "rule1",
      "priority": 10,
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "ruleType": "Basic",
      "type": "Microsoft.Network/applicationGateways/requestRoutingRules"
    },
    {
      "backendAddressPool": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendAddressPools/vm1-nerd-ip-pool",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "backendHttpSettings": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/backendHttpSettingsCollection/appGatewayBackendHttpSettings",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "httpListener": {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/httpListeners/vm1-http-listener",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      },
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/requestRoutingRules/rule-vm1-http",
      "name": "rule-vm1-http",
      "priority": 100,
      "provisioningState": "Succeeded",
      "resourceGroup": "rg-terchris-arck-rg-eus",
      "ruleType": "Basic",
      "type": "Microsoft.Network/applicationGateways/requestRoutingRules"
    }
  ],
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "resourceGuid": "efea21d0-e5ee-4caf-ae77-738a3bd7c848",
  "rewriteRuleSets": [],
  "routingRules": [],
  "sku": {
    "capacity": 1,
    "name": "Standard_v2",
    "tier": "Standard_v2"
  },
  "sslCertificates": [
    {
      "etag": "W/\"76a6a490-7047-4846-80de-eda9de8a5c17\"",
      "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/applicationGateways/appgw-eus/sslCertificates/christensen-ssl-cert",
      "name": "christensen-ssl-cert",
      "provisioningState": "Succeeded",
      "publicCertData": "long base64 string",
      "resourceGroup": "rg-terchris-arck-rg-eus",
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

Create the HTTPS rule for the subdomain vm1.christensen.no:

```bash
az network application-gateway rule create \
    --resource-group rg-terchris-arck-rg-eus \
    --gateway-name appgw-eus \
    --name rule-vm1-https \
    --http-listener vm1-https-listener \
    --rule-type Basic \
    --address-pool vm1-nerd-ip-pool \
    --priority 110
```

output is:

```json
long ling of json
```
