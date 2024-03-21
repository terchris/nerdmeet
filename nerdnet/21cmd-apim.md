# cmd apim

## API Management Service

### Create the API Management Service

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

### Adding the Azure Functions to the APIM

#### Create swagger file for the TestFunction

We will use Bicep to define the two functions in the TestFunction and Bicep needs to refer to a swagger file.
The swagger file for the two functions is in the file [testfunction.json](./landing-api/swagger/testfunction.json).

#### Import the swagger file to the APIM using Bicep

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

Output is:

```json
{
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Resources/deployments/testfunction-apis",
  "location": null,
  "name": "testfunction-apis",
  "properties": {
    "correlationId": "ff90961d-db26-4d8d-8275-60b97c040ee9",
    "debugSetting": null,
    "dependencies": [],
    "duration": "PT18.4052816S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.ApiManagement/service/apim-api-nerd-eus/apis/testFunctionApi",
        "resourceGroup": "rg-terchris-arck-rg-eus"
      }
    ],
    "outputs": {
      "apiId": {
        "type": "String",
        "value": "testFunctionApi"
      }
    },
    "parameters": {
      "apiManagementServiceName": {
        "type": "String",
        "value": "apim-api-nerd-eus"
      },
      "apiName": {
        "type": "String",
        "value": "testFunctionApi"
      },
      "apiPath": {
        "type": "String",
        "value": "testfunction"
      },
      "swaggerFileUrl": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/terchris/nerdmeet/main/nerdnet/landing-api/swagger/testfunction.json"
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
    "templateHash": "10224035344021152217",
    "templateLink": null,
    "timestamp": "2024-03-19T16:12:25.371840+00:00",
    "validatedResources": null
  },
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
```


TODO: get functions to work via APIM
