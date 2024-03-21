# cmd landing k8s

## Kubernetes Landing Zone Setup

The k8s landing zone have kubernetes installed and running. The cluster will just havea test container running.
The container will be a simple web server that returns the hostname of the container.
The cluster be placed on the subnet k8s-backend-sn01-eus and it cannot be accessed from the internet.

This file contains all commands to set up the k8s landing zone. For overview see the [Network Landing Zones](9nerdnet-network.md) file.

We will create it as a free tier cluster.

### Create the AKS cluster

name: aks-k8s-np-nerdmeet-eus

* aks-k8s-np-nerdmeet-eus Explanation:
* aks: Azure Kubernetes Service.
* k8s: Kubernetes.
* np: Non-production. Indicating this is intended for development,testing, or staging environments.
* nerdmeet: The project or application name.
* eus: East US. The Azure region identifier.

In order to connect the cluster to the subnet k8s-backend-sn01-eus we need to know the subscription id:

```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo $SUBSCRIPTION_ID
```

Create the AKS cluster with the following command:

```bash
az aks create \
  --resource-group rg-terchris-arck-rg-eus \
  --name aks-k8s-np-nerdmeet-eus \
  --enable-managed-identity \
  --node-count 1 \
  --generate-ssh-keys \
  --network-plugin azure \
  --vnet-subnet-id /subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/k8s-backend-sn01-eus \
  --location eastus \
  --tier Free

```

Output is:

```json
docker_bridge_cidr is not a known attribute of class <class 'azure.mgmt.containerservice.v2024_01_01.models._models_py3.ContainerServiceNetworkProfile'> and will be ignored
{
  "aadProfile": null,
  "addonProfiles": null,
  "agentPoolProfiles": [
    {
      "availabilityZones": null,
      "capacityReservationGroupId": null,
      "count": 1,
      "creationData": null,
      "currentOrchestratorVersion": "1.27.9",
      "enableAutoScaling": false,
      "enableEncryptionAtHost": false,
      "enableFips": false,
      "enableNodePublicIp": false,
      "enableUltraSsd": false,
      "gpuInstanceProfile": null,
      "hostGroupId": null,
      "kubeletConfig": null,
      "kubeletDiskType": "OS",
      "linuxOsConfig": null,
      "maxCount": null,
      "maxPods": 30,
      "minCount": null,
      "mode": "System",
      "name": "nodepool1",
      "networkProfile": null,
      "nodeImageVersion": "AKSUbuntu-2204gen2containerd-202403.04.0",
      "nodeLabels": null,
      "nodePublicIpPrefixId": null,
      "nodeTaints": null,
      "orchestratorVersion": "1.27.9",
      "osDiskSizeGb": 128,
      "osDiskType": "Managed",
      "osSku": "Ubuntu",
      "osType": "Linux",
      "podSubnetId": null,
      "powerState": {
        "code": "Running"
      },
      "provisioningState": "Succeeded",
      "proximityPlacementGroupId": null,
      "scaleDownMode": null,
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "spotMaxPrice": null,
      "tags": null,
      "type": "VirtualMachineScaleSets",
      "upgradeSettings": {
        "drainTimeoutInMinutes": null,
        "maxSurge": null,
        "nodeSoakDurationInMinutes": null
      },
      "vmSize": "Standard_DS2_v2",
      "vnetSubnetId": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/rg-terchris-arck-rg-eus/providers/Microsoft.Network/virtualNetworks/vnet-eus/subnets/k8s-backend-sn01-eus",
      "workloadRuntime": null
    }
  ],
  "apiServerAccessProfile": null,
  "autoScalerProfile": null,
  "autoUpgradeProfile": {
    "nodeOsUpgradeChannel": "NodeImage",
    "upgradeChannel": null
  },
  "azureMonitorProfile": null,
  "azurePortalFqdn": "aks-k8s-np-rg-terchris-arck-2c39e3-vbeqdslw.portal.hcp.eastus.azmk8s.io",
  "currentKubernetesVersion": "1.27.9",
  "disableLocalAccounts": false,
  "diskEncryptionSetId": null,
  "dnsPrefix": "aks-k8s-np-rg-terchris-arck-2c39e3",
  "enablePodSecurityPolicy": null,
  "enableRbac": true,
  "extendedLocation": null,
  "fqdn": "aks-k8s-np-rg-terchris-arck-2c39e3-vbeqdslw.hcp.eastus.azmk8s.io",
  "fqdnSubdomain": null,
  "httpProxyConfig": null,
  "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourcegroups/rg-terchris-arck-rg-eus/providers/Microsoft.ContainerService/managedClusters/aks-k8s-np-nerdmeet-eus",
  "identity": {
    "delegatedResources": null,
    "principalId": "b77fb1ed-a785-461d-a3fa-1a98a9c477f2",
    "tenantId": "bbb10281-563a-439a-8984-058647a46d2c",
    "type": "SystemAssigned",
    "userAssignedIdentities": null
  },
  "identityProfile": {
    "kubeletidentity": {
      "clientId": "276900f6-bd6c-4c90-8562-6dfcd0798537",
      "objectId": "a8cfa44e-33ac-4a04-8ed7-09666c95aac6",
      "resourceId": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourcegroups/MC_rg-terchris-arck-rg-eus_aks-k8s-np-nerdmeet-eus_eastus/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks-k8s-np-nerdmeet-eus-agentpool"
    }
  },
  "ingressProfile": null,
  "kubernetesVersion": "1.27",
  "linuxProfile": {
    "adminUsername": "azureuser",
    "ssh": {
      "publicKeys": [
        {
          "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClvZAFmBnZ4sDWSogSi4Uo/yxb8pTTK6YSL8vUtF94P52Ff4OqoEowCx3Tz+MCszNjiaKo5qliRkpBp4XR+9DOCh0eS/LwHLnwdCfiyH+5oT7a/lyzy4uLXSJgH0PCLUg3kXi7kKYbRZfD6M/rRxTy1B7+9QGrOijNj7T8Nh2R0PZ8D5a6kpBUermm03PE1cP5GLwH7goEPotwrW5Ss2+ZJYAYXLF+9pPr01bnhIU1r8ZBR+D0lUs0NXYmOKYW+ATb1lUTaqLJmrsX/pgNYW9sgia8q3JsvwKft2G974QE4gSWz5x9CawNrfghh8Jrl8hjXiSXReTqrmD15YxpVhQd"
        }
      ]
    }
  },
  "location": "eastus",
  "maxAgentPools": 100,
  "name": "aks-k8s-np-nerdmeet-eus",
  "networkProfile": {
    "dnsServiceIp": "10.0.0.10",
    "ipFamilies": [
      "IPv4"
    ],
    "loadBalancerProfile": {
      "allocatedOutboundPorts": null,
      "backendPoolType": "nodeIPConfiguration",
      "effectiveOutboundIPs": [
        {
          "id": "/subscriptions/2c39e355-0751-4cdf-81d7-737b0005c0ba/resourceGroups/MC_rg-terchris-arck-rg-eus_aks-k8s-np-nerdmeet-eus_eastus/providers/Microsoft.Network/publicIPAddresses/d59d8dcd-aab1-4f3a-8cfa-feb08f3b892a",
          "resourceGroup": "MC_rg-terchris-arck-rg-eus_aks-k8s-np-nerdmeet-eus_eastus"
        }
      ],
      "enableMultipleStandardLoadBalancers": null,
      "idleTimeoutInMinutes": null,
      "managedOutboundIPs": {
        "count": 1,
        "countIpv6": null
      },
      "outboundIPs": null,
      "outboundIpPrefixes": null
    },
    "loadBalancerSku": "Standard",
    "natGatewayProfile": null,
    "networkDataplane": "azure",
    "networkMode": null,
    "networkPlugin": "azure",
    "networkPluginMode": null,
    "networkPolicy": null,
    "outboundType": "loadBalancer",
    "podCidr": null,
    "podCidrs": null,
    "serviceCidr": "10.0.0.0/16",
    "serviceCidrs": [
      "10.0.0.0/16"
    ]
  },
  "nodeResourceGroup": "MC_rg-terchris-arck-rg-eus_aks-k8s-np-nerdmeet-eus_eastus",
  "oidcIssuerProfile": {
    "enabled": false,
    "issuerUrl": null
  },
  "podIdentityProfile": null,
  "powerState": {
    "code": "Running"
  },
  "privateFqdn": null,
  "privateLinkResources": null,
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "rg-terchris-arck-rg-eus",
  "resourceUid": "65f95b62ee972c0001c211fd",
  "securityProfile": {
    "azureKeyVaultKms": null,
    "defender": null,
    "imageCleaner": null,
    "workloadIdentity": null
  },
  "serviceMeshProfile": null,
  "servicePrincipalProfile": {
    "clientId": "msi",
    "secret": null
  },
  "sku": {
    "name": "Base",
    "tier": "Free"
  },
  "storageProfile": {
    "blobCsiDriver": null,
    "diskCsiDriver": {
      "enabled": true
    },
    "fileCsiDriver": {
      "enabled": true
    },
    "snapshotController": {
      "enabled": true
    }
  },
  "supportPlan": "KubernetesOfficial",
  "systemData": null,
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusters",
  "upgradeSettings": null,
  "windowsProfile": {
    "adminPassword": null,
    "adminUsername": "azureuser",
    "enableCsiProxy": true,
    "gmsaProfile": null,
    "licenseType": null
  },
  "workloadAutoScalerProfile": {
    "keda": null,
    "verticalPodAutoscaler": null
  }
}
```

### Get Credentials for the cluster

Get the credentials for the AKS cluster with the following command:

```bash
az aks get-credentials --resource-group rg-terchris-arck-rg-eus --name aks-k8s-np-nerdmeet-eus
```

Output is:

```text
Merged "aks-k8s-np-nerdmeet-eus" as current context in /Users/terchris/.kube/config
```

Be aware that this file is needed to connect to the cluster.

### Install kubectl for managing the AKS cluster

In order to connect to the AKS cluster, you need to install the Azure CLI extension for Kubernetes.
For mac install do:

```bash
brew install kubectl
```

Test that you can connect to the cluster:

```bash
kubectl get nodes
```

Output is:

```text
NAME                                STATUS   ROLES   AGE   VERSION
aks-nodepool1-34366886-vmss000000   Ready    agent   20m   v1.27.9
```

There is a good tool for working with the cluster named [k9s](https://k9scli.io/) Install it with:

```bash
brew install k9s
```

### Verifying the cluster

We will set up ngnix in the cluster and verify that it is running.
A simple nginx definition is in the file [test-nginx.yaml](./landing-k8s/test-nginx.yaml).

Create the nginx deployment with the following command:

```bash
kubectl apply -f ./landing-k8s/test-nginx.yaml
```

Output is:

```text
deployment.apps/nginx-deployment created
service/nginx-service created
```

Verify that the deployment is running:

```bash
kubectl get pods
```

Output is:

```text
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-57d84f57dc-gqjx7   1/1     Running   0          49s
```

Displaying the web page from the nginx deployment.
To do this we must first forward the port from the cluster to the local machine.

This command forwards the port 80 from the nginx-service to the local port 8080:

```bash
kubectl port-forward service/nginx-service 8080:80
```

Output is:

```text
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

Open a browser and go to [http://localhost:8080](http://localhost:8080) and you should see the nginx welcome page.
Or use curl:

```bash
curl http://localhost:8080
```

To stop the port forwarding use `ctrl-c`.

You can also delete the deployment with:

```bash
kubectl delete -f ./landing-k8s/test-nginx.yaml
```

But leave it running as we will need it when testing the application gateway.
