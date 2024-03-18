# Creating CAF environment

The CAF is set up in the helpers.no subscription in Azure.

CAF defines some best practices and one of them is naming conventions.
We will use the naming conventions from CAF.

## Naming conventions

we just ask chatGPT to figure it out for us.

## Login to Helpers.no Azure account

Log in to Helpers.no Azure account
Helpers subscription key is (serach for subscriptions in the portal): 5b1c5fdf-89a3-494b-9c42-5604757fecaa

```bash
az login --subscription "5b1c5fdf-89a3-494b-9c42-5604757fecaa"
```

You will get a json back with the details of the subscription.

```json
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "780144c7-ffef-4e8f-93f2-18d3058eab0f",
    "id": "5b1c5fdf-89a3-494b-9c42-5604757fecaa",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Microsoft Azure Sponsorship",
    "state": "Enabled",
    "tenantId": "780144c7-ffef-4e8f-93f2-18d3058eab0f",
    "user": {
      "name": "terchris@helpersno.onmicrosoft.com",
      "type": "user"
    }
  }
]
```

Make sure that you are working in the correct subscription.

```bash
az account set --subscription "5b1c5fdf-89a3-494b-9c42-5604757fecaa"
```

## Create resource group

The resource group has the name rg-test-arck-rg-euw accoring to the naming conventions from CAF.

```bash
az group create --name rg-test-arck-rg-euw --location westeurope
```

You will get this json back:

```json
{
  "id": "/subscriptions/5b1c5fdf-89a3-494b-9c42-5604757fecaa/resourceGroups/rg-test-arck-rg-euw",
  "location": "westeurope",
  "managedBy": null,
  "name": "rg-test-arck-rg-euw",
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
vnet : intg-vnet-weu
subnet : intg-appgw-sn01

```bash
az network vnet create --name intg-vnet-weu --resource-group rg-test-arck-rg-euw --location westeurope --address-prefix 10.0.0.0/16 --subnet-name intg-appgw-sn01 --subnet-prefix 10.0.1.0/24
```

You will get this json back:

```json
{
  "newVNet": {
    "addressSpace": {
      "addressPrefixes": [
        "10.0.0.0/16"
      ]
    },
    "enableDdosProtection": false,
    "etag": "W/\"8fbc14d0-564e-4b54-8274-3d656f2f17f3\"",
    "id": "/subscriptions/5b1c5fdf-89a3-494b-9c42-5604757fecaa/resourceGroups/rg-test-arck-rg-euw/providers/Microsoft.Network/virtualNetworks/intg-vnet-weu",
    "location": "westeurope",
    "name": "intg-vnet-weu",
    "provisioningState": "Succeeded",
    "resourceGroup": "rg-test-arck-rg-euw",
    "resourceGuid": "31f7af2d-7729-4735-b16f-3c1564e0ad3d",
    "subnets": [
      {
        "addressPrefix": "10.0.1.0/24",
        "delegations": [],
        "etag": "W/\"8fbc14d0-564e-4b54-8274-3d656f2f17f3\"",
        "id": "/subscriptions/5b1c5fdf-89a3-494b-9c42-5604757fecaa/resourceGroups/rg-test-arck-rg-euw/providers/Microsoft.Network/virtualNetworks/intg-vnet-weu/subnets/intg-appgw-sn01",
        "name": "intg-appgw-sn01",
        "privateEndpointNetworkPolicies": "Disabled",
        "privateLinkServiceNetworkPolicies": "Enabled",
        "provisioningState": "Succeeded",
        "resourceGroup": "rg-test-arck-rg-euw",
        "type": "Microsoft.Network/virtualNetworks/subnets"
      }
    ],
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": []
  }
}
```

You can list the vnet and subnet like this:

```bash
az network vnet list --resource-group rg-test-arck-rg-euw --output table
```

You will get this table back:

```bash
Name           ResourceGroup        Location    NumSubnets    Prefixes     DnsServers    DDOSProtection    VMProtection
-------------  -------------------  ----------  ------------  -----------  ------------  ----------------  --------------
intg-vnet-weu  rg-test-arck-rg-euw  westeurope  1             10.0.0.0/16                False
```

```bash
az network vnet subnet list --vnet-name intg-vnet-weu --resource-group rg-test-arck-rg-euw --output table
```

You will get this table back:

```bash
AddressPrefix    Name             PrivateEndpointNetworkPolicies    PrivateLinkServiceNetworkPolicies    ProvisioningState    ResourceGroup
---------------  ---------------  --------------------------------  -----------------------------------  -------------------  -------------------
10.0.1.0/24      intg-appgw-sn01  Disabled                          Enabled                              Succeeded            rg-test-arck-rg-euw
```

#### Create a Public IP Address for the Application Gateway

Name of the public ip address: intg-appgw-pip-weu

```bash
az network public-ip create --resource-group rg-test-arck-rg-euw --name intg-appgw-pip-weu --allocation-method Static --sku Standard --location westeurope
```

you will get this json back:

```json
[Coming breaking change] In the coming release, the default behavior will be changed as follows when sku is Standard and zone is not provided: For zonal regions, you will get a zone-redundant IP indicated by zones:["1","2","3"]; For non-zonal regions, you will get a non zone-redundant IP indicated by zones:null.
{
  "publicIp": {
    "ddosSettings": {
      "protectionMode": "VirtualNetworkInherited"
    },
    "etag": "W/\"28cd97f9-134a-46c2-ae2d-b1ea4e87d480\"",
    "id": "/subscriptions/5b1c5fdf-89a3-494b-9c42-5604757fecaa/resourceGroups/rg-test-arck-rg-euw/providers/Microsoft.Network/publicIPAddresses/intg-appgw-pip-weu",
    "idleTimeoutInMinutes": 4,
    "ipAddress": "20.73.173.48",
    "ipTags": [],
    "location": "westeurope",
    "name": "intg-appgw-pip-weu",
    "provisioningState": "Succeeded",
    "publicIPAddressVersion": "IPv4",
    "publicIPAllocationMethod": "Static",
    "resourceGroup": "rg-test-arck-rg-euw",
    "resourceGuid": "b9d4818c-c7f8-412d-b495-2789b8e6307f",
    "sku": {
      "name": "Standard",
      "tier": "Regional"
    },
    "type": "Microsoft.Network/publicIPAddresses"
  }
}
```

you can list the public ip address like this:

```bash
az network public-ip list --resource-group rg-test-arck-rg-euw --output table
```


The IP address is: 20.73.173.48
I use fastname to admin the domain and I will add an A record for the domain api.arezibo.no to point to this IP address.

Testing that the DNS is working:
```bash
ping api.arezibo.no
PING api.arezibo.no (20.73.173.48): 56 data bytes
```

Note: I decide to ignore the warning about the coming breaking change as adding zones can incure extra cost.


#### a SSL certificate is needed and we use Let's Encrypt

This task if you dont have a SSL certificate for the domain arezibo.no.

```bash
brew install certbot
```

Now we can create the certificate using the DNS challenge. We want the certificate for all of the subdomains of arezibo.no.

```bash
certbot certonly --manual --preferred-challenges=dns --email terje@arezibo.no -d "*.arezibo.no" -d arezibo.no
```

See the file infrastructure/azure-caf/3ssl-create.md for the output of the command.

Convert the Certificate to PFX Format
```bash
cd secrets

openssl pkcs12 -export -out arezibo.no.pfx -inkey letsencrypt/live/arezibo.no/privkey.pem -in letsencrypt/live/arezibo.no/fullchain.pem -passout pass:JALLA!
```





#### Create the Application Gateway with WAF v2


Name of the application gateway: intg-appgw-weu


```bash
az network application-gateway create \
  --name intg-appgw-weu \
  --location westeurope \
  --resource-group rg-test-arck-rg-euw \
  --sku WAF_v2 \
  --public-ip-address intg-appgw-pip-weu \
  --vnet-name intg-vnet-weu \
  --subnet intg-appgw-sn01 \
  --no-wait

```





Upload the Certificate to Azure Application Gateway
```bash
az network application-gateway ssl-cert create \
  --resource-group rg-test-arck-rg-euw \
  --gateway-name intg-appgw-weu \
  --name areziboSSLCert \
  --cert-file arezibo.no.pfx \
  --cert-password JALLA!
```



#### Create APIM
We create SKU Developer as it has the networking features we need.The upcomming Standard v2 SKU is not available in the az cli yet.

```bash
az apim create --name intg-apim-weu --resource-group rg-test-arck-rg-euw --publisher-email "terje@helpers.no" --publisher-name "Helpers.no" --sku-name Developer --location westeurope
```

You get this json back:

```json
{
  "etag": "W/\"8fbc14d0-564e-4b54-8274-3d656f2f17f3\"",
  "id": "/subscriptions/5b1c5fdf-89a3-494b-9c42-5604757fecaa/resourceGroups/rg-test-arck-rg-euw/providers/Microsoft.ApiManagement/service/intg-apim-weu",
  "location": "westeurope",
  "name": "intg-apim-weu",
  "provisioningState": "Succeeded",
  "resourceGroup": "rg-test-arck-rg-euw",
  "sku": {
    "capacity": 1,
    "name": "Developer"
  },
  "tags": null,
  "type": "Microsoft.ApiManagement/service"
}
```