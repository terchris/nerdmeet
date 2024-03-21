# cmd storage

## Storage

### Create the Azure Storage Account

Each function will need a storage account to store the function code and logs. Functions have separate storage accounts so that different teams do not interfere with each other. This is a best practice for isolation and security.

A storage account is only available in the subnet where the function is located. 
TODO: this is strict - check it out.

Storage account for the test function named func-api-testfunction-int001-eus-01 is named: stapitestfnint001eus01

Create the storage account with the following command:

```bash
az storage account create \
  --name stapitestfnint001eus01 \
  --resource-group rg-terchris-arck-rg-eus \
  --location eastus \
  --sku Standard_LRS
```

Output is:

```json
{
  "accessTier": "Hot",
  "accountMigrationInProgress": null,
  "allowBlobPublicAccess": false,
  "allowCrossTenantReplication": false,
  "allowSharedKeyAccess": null,
  "allowedCopyScope": null,
  "azureFilesIdentityBasedAuthentication": null,
  "blobRestoreStatus": null,
  "creationTime": "2024-03-19T11:15:09.879667+00:00",
  "customDomain": null,
  "defaultToOAuthAuthentication": null,
  "dnsEndpointType": null,
  "enableHttpsTrafficOnly": true,
  "enableNfsV3": null,
  "encryption": {
    "encryptionIdentity": null,
    "keySource": "Microsoft.Storage",
    "keyVaultProperties": null,
    "requireInfrastructureEncryption": null,
    "services": {
      "blob": {
        "enabled": true,
        "keyType": "Account",
        "lastEnabledTime": "2024-03-19T11:15:11.129664+00:00"
      },
      "file": {
        "enabled": true,
        "keyType": "Account",
        "lastEnabledTime": "2024-03-19T11:15:11.129664+00:00"
      },
      "queue": null,
      "table": null
    }
  },
  "extendedLocation": null,
  "failoverInProgress": null,
  "geoReplicationStats": null,
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Storage/storageAccounts/stapitestfnint001eus01",
  "identity": null,
  "immutableStorageWithVersioning": null,
  "isHnsEnabled": null,
  "isLocalUserEnabled": null,
  "isSftpEnabled": null,
  "isSkuConversionBlocked": null,
  "keyCreationTime": {
    "key1": "2024-03-19T11:15:10.114045+00:00",
    "key2": "2024-03-19T11:15:10.114045+00:00"
  },
  "keyPolicy": null,
  "kind": "StorageV2",
  "largeFileSharesState": null,
  "lastGeoFailoverTime": null,
  "location": "eastus",
  "minimumTlsVersion": "TLS1_0",
  "name": "stapitestfnint001eus01",
  "networkRuleSet": {
    "bypass": "AzureServices",
    "defaultAction": "Allow",
    "ipRules": [],
    "ipv6Rules": [],
    "resourceAccessRules": null,
    "virtualNetworkRules": []
  },
  "primaryEndpoints": {
    "blob": "https://stapitestfnint001eus01.blob.core.windows.net/",
    "dfs": "https://stapitestfnint001eus01.dfs.core.windows.net/",
    "file": "https://stapitestfnint001eus01.file.core.windows.net/",
    "internetEndpoints": null,
    "microsoftEndpoints": null,
    "queue": "https://stapitestfnint001eus01.queue.core.windows.net/",
    "table": "https://stapitestfnint001eus01.table.core.windows.net/",
    "web": "https://stapitestfnint001eus01.z13.web.core.windows.net/"
  },
  "primaryLocation": "eastus",
  "privateEndpointConnections": [],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "routingPreference": null,
  "sasPolicy": null,
  "secondaryEndpoints": null,
  "secondaryLocation": null,
  "sku": {
    "name": "Standard_LRS",
    "tier": "Standard"
  },
  "statusOfPrimary": "available",
  "statusOfSecondary": null,
  "storageAccountSkuConversionStatus": null,
  "tags": {},
  "type": "Microsoft.Storage/storageAccounts"
}
````

### Securing Azure Storage Account

TODO: This is not done yet.

To set the storage account to only be accessible from the subnet api-backend-sn01-eus we need to get the subnet id:

```bash
APISUBNET_ID=$(az network vnet subnet show --resource-group rg-terchris-arck-rg-eus --vnet-name vnet-eus --name api-backend-sn01-eus --query id -o tsv)

echo $APISUBNET_ID
```

Output is:

```text
/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/api-backend-sn01-eus
```

Set the storage account to only be accessible from the subnet api-backend-sn01-eus with the following command:

```bash
az storage account network-rule add --resource-group rg-terchris-arck-rg-eus --account-name stapitestfnint001eus01 --subnet $APISUBNET_ID
```

Output is:

```json
?todo
```

### Verifying Azure Storage Account

To verify that the storage account is created do:

```bash
az storage account list --resource-group rg-terchris-arck-rg-eus --output table
```

Output is:

```text
AccessTier    AllowBlobPublicAccess    AllowCrossTenantReplication    CreationTime                      EnableHttpsTrafficOnly    Kind       Location    MinimumTlsVersion    Name                    PrimaryLocation    ProvisioningState    ResourceGroup            StatusOfPrimary
------------  -----------------------  -----------------------------  --------------------------------  ------------------------  ---------  ----------  -------------------  ----------------------  -----------------  -------------------  -----------------------  -----------------
Hot           False                    False                          2024-03-19T11:15:09.879667+00:00  True                      StorageV2  eastus      TLS1_0               stapitestfnint001eus01  eastus             Succeeded            rg-terchris-arck-rg-eus  available
```
