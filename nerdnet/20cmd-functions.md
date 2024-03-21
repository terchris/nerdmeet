# cmd functions

## Azure Functions

### Create the Azure Functions

( not possible in the cheapest version The Azure Functions will be used to test the APIM. The Azure functions will be placed in the subnet api-backend-sn01-eus and they cannot be accessed from the internet.)

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

If you need to delete the function app you can do it with this command:

```bash
az functionapp delete --name func-api-testfunction-int001-eus-01 --resource-group rg-terchris-arck-rg-eus
```

#### Securing Azure Functions

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
SUBNET_ID=$(az network vnet subnet show --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --name api-backend-sn01-eus --query id -o tsv)
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

#### Verifying Azure Functions

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

### Adding code to the test function

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

### Testing the functions

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
