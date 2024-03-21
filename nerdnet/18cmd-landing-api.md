# cmd landing api

## api Landing Zone Setup

The api landing zone will have an API Management service (APIM).
The APIM will get its traffic from the Application Gateway and it will be placed in the subnet api-backend-sn01-eus and it cannot be accessed from the internet.

( This is not possible in the cheapest version There will also be two Azure functions that will be used to test the APIM. The Azure functions will be placed in the subnet api-backend-sn01-eus and and they cannot be accessed from the internet.)

It is best to set up Azure Functions first and make sure they work before adding them to APIM.

This file references to documents on how to set up the api landing zone. For overview see the [Network Landing Zones](9nerdnet-network.md) file.


## Azure Functions, APIM and storage

The firewall will route traffic to APIM. The APIM will route traffic to the Azure Functions.
Azure functions need a storage account to work.
The table below describes the tasks needed to set it up in the correct order.

Name of the storage account : `stapitestfnint001eus01`
The name of the storage account must be unique across all of Azure globally.
This is a challenge and we have shortened the name according to CAF naming conventions. So the name is broken up to:

* `st` - Storage Account
* `api` - Landing Zone
* `testfn` - test function
* `int001` - refering to integration ID int001
* `eus` - East US region
* `01` - Hex numbering to make the name unique

Name of the function we use for the initial setup is `func-api-testfunction-int001-eus-01`.
According to CAF naming conventions the name is broken up to:

* `func` - Azure Function
* `api` - Landing Zone
* `testfunction` - test function
* `int001` - refering to integration ID int001
* `eus` - East US region
* `01` - Hex numbering to make the name unique



| Task | Description |
|------|-------------|
| [Create a storage account](19cmd-storage.md) | First ste up a storage account for the Azure Functions. |
| [Create the function](20cmd-functions.md) | Create the Azure Functions  |
| [Add code to the function](20cmd-functions.md) | A simple node program in javascript just for testing  |
| [Configure APIM to call the function](21cmd-apim.md) | Set up APIM to call the function TODO: Not working   |
| Configure firewall to route to APIM  | TODO   |

Other info:

| What | Where |
|------|-------|
| [Bicep for APIM](landing-api/apim-bicep/testfunction-apis.bicep) | How to set up APIM using Bicep |
| [Swagger for APIM](landing-api/swagger/testfunction.json) | Swagger file for the Azure Functions |
| [TestFunction](landing-api/TestFunction/readme.md) | Code for the TestFunction (javascript/node) |
