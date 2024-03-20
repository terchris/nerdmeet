# Claud Azure

The nerdmet is running in Azure.

## Firewall: Application Gateway

The Application Gateway is the only resource with a public IP address. The Application Gateway terminates SSL and routes traffic based on subdomain.

## API Gateway: API Manager (APIM)

We use Azure API Management (APIM) to manage and protect APIs. APIM is not exposed directly on the internet. It is only accessible through the Application Gateway.

## serverless functions: Azure Functions

We use Azure Functions to run serverless functions. Azure Functions is not exposed directly on the internet. They are only accessible through APIM witch in turn is only accesible via the Application Gateway.

## kubernetes: Azure kubernetes service (AKS)

We use Azure Kubernetes Service (AKS) to run kubernetes clusters. AKS is not exposed directly on the internet. It is only accessible through the Application Gateway.
