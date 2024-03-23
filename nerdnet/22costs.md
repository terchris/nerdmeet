# costs

To reduce costs we will stop stuff that is not in use.


## what resources are there

### List all resources 

```bash
az resource list --resource-group rg-terchris-arck-rg-eus -o table
```

```text
Name                                                     ResourceGroup            Location    Type                                                Status
-------------------------------------------------------  -----------------------  ----------  --------------------------------------------------  --------
vnet-eus                                                 rg-terchris-arck-rg-eus  eastus      Microsoft.Network/virtualNetworks
appgw-pip-eus                                            rg-terchris-arck-rg-eus  eastus      Microsoft.Network/publicIPAddresses
nerd-vm01-nic-eus                                        rg-terchris-arck-rg-eus  eastus      Microsoft.Network/networkInterfaces
nerd-vm01-eus                                            rg-terchris-arck-rg-eus  eastus      Microsoft.Compute/virtualMachines
nerd-vm01-eus_disk1_0f5d331ce4a04274a93fc21603d07b85     RG-TERCHRIS-ARCK-RG-EUS  eastus      Microsoft.Compute/disks
aks-k8s-np-nerdmeet-eus                                  rg-terchris-arck-rg-eus  eastus      Microsoft.ContainerService/managedClusters
stapitestfnint001eus01                                   rg-terchris-arck-rg-eus  eastus      Microsoft.Storage/storageAccounts
func-api-testfunction-int001-eus-01                      rg-terchris-arck-rg-eus  eastus      Microsoft.Web/sites
func-api-testfunction-int001-eus-01                      rg-terchris-arck-rg-eus  eastus      Microsoft.Insights/components
EastUSPlan                                               rg-terchris-arck-rg-eus  eastus      Microsoft.Web/serverFarms
Application Insights Smart Detection                     rg-terchris-arck-rg-eus  global      microsoft.insights/actiongroups
Failure Anomalies - func-api-testfunction-int001-eus-01  rg-terchris-arck-rg-eus  global      microsoft.alertsmanagement/smartDetectorAlertRules
apim-api-nerd-eus                                        rg-terchris-arck-rg-eus  eastus      Microsoft.ApiManagement/service
appgw-eus                                                rg-terchris-arck-rg-eus  eastus      Microsoft.Network/applicationGateways
```

### List all VM's

```bash
az vm list -d --resource-group rg-terchris-arck-rg-eus --query "[].{Name:name, PowerState:powerState}" -o table
```

```text
Name           PowerState
-------------  --------------
nerd-vm01-eus  VM deallocated
```

### List all Web Apps, Function Apps

```bash
az webapp list --resource-group rg-terchris-arck-rg-eus --query "[].{Name:name, State:state}" -o table
```
If there are no output there are none running.





## Stopping and starting kubernetes cluster

### Stopping kubernetes cluster


```bash
az aks stop --name aks-k8s-np-nerdmeet-eus --resource-group rg-terchris-arck-rg-eus
```

### Starting the cluster again

```bash
az aks start --name aks-k8s-np-nerdmeet-eus --resource-group rg-terchris-arck-rg-eus
```

### Check if the cluster is stopped

We can scale the cluster down to 0 nodes. This redices costs. But there will still be cost for load balancer etc.

```bash
az aks list --query "[].{Name:name, ResourceGroup:resourceGroup, Location:location, KubernetesVersion:kubernetesVersion, NodeCount:agentPoolProfiles[0].count, ProvisioningState:provisioningState}" -o table
```

```text
Name                     ResourceGroup            Location    KubernetesVersion    NodeCount    ProvisioningState
-----------------------  -----------------------  ----------  -------------------  -----------  -------------------
aks-k8s-np-nerdmeet-eus  rg-terchris-arck-rg-eus  eastus      1.27                 0            Succeeded
```

## Stopping and starting VMs

### Stopping the nerd-vm01-eus

```bash
az vm deallocate --resource-group rg-terchris-arck-rg-eus --name nerd-vm01-eus
```

The disk cost for the VM will still be there. So just be aware of that.
´nerd-vm01-eus_disk1_0f5d331ce4a04274a93fc21603d07b85´ is the disk

### Starting the nerd-vm01-eus

```bash

```

### Check the status of the VM

```bash
az vm show --resource-group rg-terchris-arck-rg-eus --name nerd-vm01-eus --show-details --query "{Name:name, Status:powerState}" -o table
```

```text
Name           Status
-------------  --------------
nerd-vm01-eus  VM deallocated
```

## Stopping and staring Functions

### Stopping the testfunction

```bash
az webapp stop --name func-api-testfunction-int001-eus-01 --resource-group rg-terchris-arck-rg-eus
```

### Staring the testfunction

```bash
az webapp start --name func-api-testfunction-int001-eus-01 --resource-group rg-terchris-arck-rg-eus
```

### Check the status of the testfunction

```bash
az webapp show --name func-api-testfunction-int001-eus-01 --resource-group rg-terchris-arck-rg-eus --query "state" -o tsv
```

```text
Stopped
```



