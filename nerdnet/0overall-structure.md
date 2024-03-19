# Overall structure nerd network

Domain used: christensen.no
DNS server: external dns server pointig *.christensen.no external ip for application gateway
SSL certificate: *.christensen.no gateway (wildcard) termination at application gateway

The setup follow CAF (Cloud Adoption Framework) and the following landing zones are used:

* Landing Zone: api, api for short.
* Landing Zone: nerdmeet, nerd for short.
* Landing Zone: kubernetes, k8s for short.

Clients on the Internet should only access resources through the Application Gateway. The Application Gateway should be the only resource with a public IP address.
The application gateway forwards traffic based on subdomain.

* The subdomain api.christensen.no is forwarded to the API Management in the api landing zone.
* The subdomain vm1.christensen.no is forwarded to the vm1 in nerd landing zone.
* The subdomain k8s.christensen.no is forwarded to the cluster in k8s landing zone.

The api landing zone will be used for testing Azure functions and API Management.
The nerdmeet landing zone will be used for testing AI and different VMs.
The k8s landing zone will be used for testing kubernetes.

Azure region: eastus
Resource group: rg-terchris-arck-rg-eus
Subscription owner : terchris.redcross@gmail.com
Subscription type: free trial $200 credit

## Networks

vnet name: vnet-eus
vnet address space: 10.21.0.0/16
api subnet: api-appgw-sn01-eus
api subnet address space: 10.21.0.0/24

nerd subnet name:nerd-backend-sn01-eus
nerd subnet address space: 10.21.1.0/24
nerd subnet vnet: vnet-eus

k8s subnet name:k8s-backend-sn01-eus
k8s subnet address space: 10.21.2.0/24
k8s subnet vnet: vnet-eus

## Application Gateway

application gateway name: appgw-eus
public ip address: appgw-pip-eus
public ip address: <fill in>
vnet name: vnet-eus
subnet name: api-appgw-sn01-eus
SSL certificate name : ssl-christensen
SSL setup: *.christensen.no (wildcard) termination at application gateway
Description: Application gateway forwards:
email: terje@christensen.no 
organization: Christensen.no

Rules:

* api.christensen.no http and https to APIM in the api landing zone
* vm1.christensen.no forwarded to the VM named nerd-vm01-eus in the nerd landing zone
* k8s.christensen.no to the cluster in k8s landing zone

## VM running ubuntu for testing

subnet: nerd-backend-sn01-eus
vm1 name: nerd-vm01-eus
vm1 nic name: nerd-vm01-nic-eus
vm1 domain name: vm1.christensen.no

## Azure functions app

Name: func-api-testfunction-int001-eus-01
Runtime: node (test functions are written in javascript)
defaultHostName: func-api-testfunction-int001-eus-01.azurewebsites.net
storage account name for functions: stapitestfnint001eus01
Description: Azure functions app for testing

## 2 Test functions in the Azure functions app

dayOfWeekFunction Invoke url: https://func-api-testfunction-int001-eus-01.azurewebsites.net/api/dayofweekfunction
TimeFunction Invoke url: https://func-api-testfunction-int001-eus-01.azurewebsites.net/api/timefunction

To test do: curl https://func-api-testfunction-int001-eus-01.azurewebsites.net/api/timefunction

## API Management

Name: apim-api-nerd-eus
Developer Portal URL:https://apim-api-nerd-eus.developer.azure-api.net
Gateway URL: https://apim-api-nerd-eus.azure-api.net
Management API URL: https://apim-api-nerd-eus.management.azure-api.net

