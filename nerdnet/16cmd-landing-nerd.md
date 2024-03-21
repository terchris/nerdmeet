# cmd landing nerd

## nerd Landing zone setup

The nerd landing zone will by default have just one VM for testing purposes. Named nerd-vm01-eus.
The VM will be placed in the subnet nerd-backend-sn01-eus and it cannot be accessed from the internet.

### Create network for test VM

Create the network interface for the test VM.

```bash
az network nic create \
  --resource-group rg-terchris-arck-rg-eus \
  --name nerd-vm01-nic-eus \
  --vnet-name vnet-eus \
  --subnet nerd-backend-sn01-eus
```

Output is:

```json
{
  "NewNIC": {
    "auxiliaryMode": "None",
    "auxiliarySku": "None",
    "disableTcpStateTracking": false,
    "dnsSettings": {
      "appliedDnsServers": [],
      "dnsServers": [],
      "internalDomainNameSuffix": "vxolj0r4g3aepd13fnfzflvy5g.bx.internal.cloudapp.net"
    },
    "enableAcceleratedNetworking": false,
    "enableIPForwarding": false,
    "etag": "W/\"d39dcbfe-1ff1-49fd-a874-7f420b7d630b\"",
    "hostedWorkloads": [],
    "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/networkInterfaces/nerd-vm01-nic-eus",
    "ipConfigurations": [
      {
        "etag": "W/\"d39dcbfe-1ff1-49fd-a874-7f420b7d630b\"",
        "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/networkInterfaces/nerd-vm01-nic-eus/ipConfigurations/ipconfig1",
        "name": "ipconfig1",
        "primary": true,
        "privateIPAddress": "10.21.1.4",
        "privateIPAddressVersion": "IPv4",
        "privateIPAllocationMethod": "Dynamic",
        "provisioningState": "Succeeded",
        "resourceGroup": "rg-terchris-arck-rg-eus",
        "subnet": {
          "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/nerd-backend-sn01-eus",
          "resourceGroup": "rg-terchris-arck-rg-eus"
        },
        "type": "Microsoft.Network/networkInterfaces/ipConfigurations"
      }
    ],
    "location": "eastus",
    "name": "nerd-vm01-nic-eus",
    "nicType": "Standard",
    "provisioningState": "Succeeded",
    "resourceGroup": "rg-terchris-arck-rg-eus",
    "resourceGuid": "d911d038-d8ec-43ce-b933-ae77fb345683",
    "tapConfigurations": [],
    "type": "Microsoft.Network/networkInterfaces",
    "vnetEncryptionSupported": false
  }
}
```


### Create one simple test VM

Create the cheapest test VM in the nerd landing zone.
It only purpose is to run a simple web server so that we can test the Application Gateway.
It uses [cloud-init.txt](./landing-nerd/cloud-init.txt) to install a simple web server.

Username: terchris
Name: nerd-vm01-eus

```bash
az vm create \
  --resource-group rg-terchris-arck-rg-eus \
  --name nerd-vm01-eus \
  --nics nerd-vm01-nic-eus \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username terchris \
  --generate-ssh-keys \
  --custom-data ./landing-nerd/cloud-init.txt \
  --location eastus
```

Output is:

```json
{
  "fqdns": "",
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Compute/virtualMachines/nerd-vm01-eus",
  "location": "eastus",
  "macAddress": "00-0D-3A-16-D5-7B",
  "powerState": "VM running",
  "privateIpAddress": "10.21.1.4",
  "publicIpAddress": "",
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "zones": ""
}
```

### Verify the VM is created

verify the VM is created and running:

```bash
az vm list --resource-group rg-terchris-arck-rg-eus --output table
```

output is:

```text
Name           ResourceGroup            Location    Zones
-------------  -----------------------  ----------  -------
nerd-vm01-eus  rg-terchris-arck-rg-eus  eastus
```

Check that the web server is running on the VM:

```bash
az vm run-command invoke --command-id RunShellScript --name nerd-vm01-eus --resource-group rg-terchris-arck-rg-eus --scripts "curl http://localhost"
```

output is:

```json
{
  "value": [
    {
      "code": "ProvisioningState/succeeded",
      "displayStatus": "Provisioning succeeded",
      "level": "Info",
      "message": "Enable succeeded: \n[stdout]\nHello World from host nerd-vm01-eus!\n[stderr]\n  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current\n                                 Dload  Upload   Total   Spent    Left  Speed\n\r  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r100    36  100    36    0     0    633      0 --:--:-- --:--:-- --:--:--   642\n",
      "time": null
    }
  ]
}
```
