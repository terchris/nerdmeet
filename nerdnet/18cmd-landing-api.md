# cmd landing api

## Task 7: api Landing Zone Setup

The api landing zone will have an API Management service (APIM).
The APIM will get its traffic from the Application Gateway and it will be placed in the subnet api-backend-sn01-eus and it cannot be accessed from the internet.

( This is not possible in the cheapest version There will also be two Azure functions that will be used to test the APIM. The Azure functions will be placed in the subnet api-backend-sn01-eus and and they cannot be accessed from the internet.)

It is best to set up Azure Functions first and make sure they work before adding them to APIM.


First ste up a storage account for the Azure Functions.
[Create a storage account](./19cmd-storage.md)

