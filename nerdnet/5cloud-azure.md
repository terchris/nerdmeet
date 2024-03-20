# Claud Azure

The nerdmet is running in Azure.

## Firewall: Azure Application Gateway

The Application Gateway is the only resource with a public IP address. The Application Gateway terminates SSL and routes traffic based on subdomain. [What is Azure Application Gateway?](https://learn.microsoft.com/en-us/azure/application-gateway/overview)

## API Gateway: Azure API Manager (APIM)

We use Azure API Management (APIM) to manage and protect APIs. APIM is not exposed directly on the internet. It is only accessible through the Application Gateway. [What is Azure API Management?](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts)

## serverless functions: Azure Functions

We use Azure Functions to run serverless functions. [Azure Functions overview](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview)

Azure Functions is not exposed directly on the internet. They are only accessible through APIM witch in turn is only accesible via the Application Gateway.

TODO: check this? PS By default functions are exposed to the internet. You need to configure the functions NOT to be exposed to the internet and only work in one Landing Zone.

## kubernetes: Azure kubernetes service (AKS)

We use Azure Kubernetes Service (AKS) to run kubernetes clusters. [Azure Kubernetes Service (AKS) overview](https://learn.microsoft.com/en-us/azure/aks/)
AKS is not exposed directly on the internet. It is only accessible through the Application Gateway.
