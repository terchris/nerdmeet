# naming using CAF

nerdnet is using CAF naming conventions.
The purpose of having defined naming standards is to make it possible to identify what a resource does and where it belongs just by looking at the name.

It creates a CleanAzure environment.

## 1 CAF naming conventions

### 1.1 CAF naming convention for the Azure Functions

We have a central register of all integrations. The IntegrationID is a unique identifier for each integration. The IntegrationID is used in the name of the function app.

The format of the integration ID is "int" followed by a three-digit number. The number is unique for each integration.

Functions need to be named in a CAF compliant way:

Name: func-api-testfunction-int001-eus-01

```text
func: Indicates the resource is a Function App.
api: Denotes the integration landing zone.
testfunction: Specifies the name of the function app.
int001: The unique IntegrationID from in our tracking system.
eus: The region abbreviation for East US.
01: a two char hex to make the name unique. An instance or sequence number for versioning or multiple instances.
```

### 1.2 CAF naming convention for Azure Storage accounts

Azure Storage account names must be between 3 and 24 characters in length and can contain only lowercase letters and numbers. And it must be unique across all of Azure.

Because of the lenght of maximum 24 characters we have limited the length of the integration ID to 6 characters.

Name: stapitestfnint001eus01

```text
st: 2 char that denotes it's a storage account.
api: max 4 char that indicate landing zone.  Indicates it's part of the api landing zone.
testfn: 6 char for the name 
int001: 6 char Integration ID 
eus: 3 char that Specifies the Azure region (East US) for the storage account.
01: a two char hex to make the name unique.
```

The above rule will use the maximum length of 24 characters.

Functions have separate storage accounts so that different teams do not interfere with each other. This is a best practice for isolation and security.
TODO: check the costs of this.

### 1.3 CAF naming convention for Azure Resource Groups

TODO: is this correct for resource groups?
Name: rg-terchris-arck-rg-eus

```text
rg: 2 char that denotes it's a resource group.
terchris: 8 char for the name of the owner.
arck: 4 char for the name of the project.
rg: 2 char for the name of the resource group.
eus: 3 char that Specifies the Azure region (East US) for the resource group.
```

### 1.4 CAF naming convention for Vnet and subnets

Name: vnet-eus

```text
vnet: 4 char that denotes it's a virtual network.
eus: 3 char that Specifies the Azure region (East US) for the virtual network.
```

Name: nerd-backend-sn01-eus

```text
nerd:  it's the nerd landing zone.
backend: backend subnet.
sn01: 4 char that denotes it's the first subnet in the nerd landing zone.
eus: 3 char that Specifies the Azure region (East US) for the subnet.
```

### 1.5 CAF naming convention for Application Gateway

Name: appgw-eus

```text
appgw: 5 char that denotes it's an application gateway.
eus: 3 char that Specifies the Azure region (East US) for the application gateway.
```

### 1.6 CAF naming convention for VMs

Name: nerd-vm01-eus

```text
nerd: 4 char that denotes it's the nerd landing zone.
vm01: 4 char that denotes it's the first VM in the nerd landing zone.
eus: 3 char that Specifies the Azure region (East US) for the VM.
```

### 1.7 CAF naming convention for Azure Kubernetes Service (AKS)

Name: aks-k8s-np-nerdmeet-eus

```text
aks: 3 char that denotes it's an Azure Kubernetes Service.
k8s: 3 char that denotes it's the k8s landing zone.
np: 2 char that denotes it's a non-production environment.
nerdmeet: 8 char that denotes the project or application name.
eus: 3 char that Specifies the Azure region (East US) for the AKS.
```
