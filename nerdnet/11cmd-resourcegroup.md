# cmd resource group

To set up a resource group, use the following command:

## Create the resource group

```bash
az group create --name rg-terchris-arck-rg-eus --location eastus
```

output is:

```json
{
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus",
  "location": "eastus",
  "managedBy": null,
  "name": "rg-terchris-arck-rg-eus",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```
