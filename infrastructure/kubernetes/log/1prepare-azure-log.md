# prepare azure kubernetes


terchris@NRX-FV64NNXDQ2 nerdmeet % az account set --subscription "PROD - IKT - AZ - RED CROSS"
terchris@NRX-FV64NNXDQ2 nerdmeet % az group list --output table
Name                   Location    Status
---------------------  ----------  ---------
rg-prod-backup-euw     westeurope  Succeeded
rg-prod-network-euw    westeurope  Succeeded
NetworkWatcherRG       westeurope  Succeeded
rg-prod-ascdf-weu      westeurope  Succeeded
rg-prod-avd-euw        westeurope  Succeeded
rg-prod-translate-euw  westeurope  Succeeded
rg-test-arck-rg-euw    westeurope  Succeeded


terchris@NRX-FV64NNXDQ2 nerdmeet % az aks create --resource-group rg-test-arck-rg-euw --name arck-rc-ikt-aks-nerdmeet-tst-euw-1 --node-count 1 --generate-ssh-keys
SSH key files '/Users/terchris/.ssh/id_rsa' and '/Users/terchris/.ssh/id_rsa.pub' have been generated under ~/.ssh to allow SSH access to the VM. If using machines without permanent storage like Azure Cloud Shell without an attached file share, back up your keys to a safe location
(RequestDisallowedByPolicy) Resource 'arck-rc-ikt-aks-nerdmeet-tst-euw-1' was disallowed by policy. Reasons: 'Public network access must be disabled for PaaS services.'. See error details for policy resource IDs.
Code: RequestDisallowedByPolicy
Message: Resource 'arck-rc-ikt-aks-nerdmeet-tst-euw-1' was disallowed by policy. Reasons: 'Public network access must be disabled for PaaS services.'. See error details for policy resource IDs.
Target: arck-rc-ikt-aks-nerdmeet-tst-euw-1
Additional Information:Type: PolicyViolation
Info: {
    "evaluationDetails": {
        "evaluatedExpressions": [
            {
                "result": "True",
                "expressionKind": "Field",
                "expression": "type",
                "path": "type",
                "expressionValue": "Microsoft.ContainerService/managedClusters",
                "targetValue": "Microsoft.ContainerService/managedClusters",
                "operator": "Equals"
            },
            {
                "result": "True",
                "expressionKind": "Field",
                "expression": "Microsoft.ContainerService/managedClusters/apiServerAccessProfile.enablePrivateCluster",
                "path": "properties.apiServerAccessProfile.enablePrivateCluster",
                "targetValue": "True",
                "operator": "NotEquals"
            }
        ],
        "reason": "Public network access must be disabled for PaaS services."
    },
    "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/040732e8-d947-40b8-95d6-854c95024bf8",
    "policySetDefinitionId": "/providers/Microsoft.Management/managementGroups/alz-prod/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints",
    "policyDefinitionReferenceId": "AKSDenyPaasPublicIP",
    "policySetDefinitionName": "Deny-PublicPaaSEndpoints",
    "policySetDefinitionDisplayName": "Public network access should be disabled for PaaS services",
    "policyDefinitionName": "040732e8-d947-40b8-95d6-854c95024bf8",
    "policyDefinitionDisplayName": "Azure Kubernetes Service Private Clusters should be enabled",
    "policyDefinitionEffect": "Deny",
    "policyAssignmentId": "/providers/Microsoft.Management/managementGroups/alz-prod-corp/providers/Microsoft.Authorization/policyAssignments/Deny-Public-Endpoints",
    "policyAssignmentName": "Deny-Public-Endpoints",
    "policyAssignmentDisplayName": "Public network access should be disabled for PaaS services",
    "policyAssignmentScope": "/providers/Microsoft.Management/managementGroups/alz-prod-corp",
    "policyAssignmentParameters": {},
    "policyExemptionIds": []
}


## failing cluster creation leaves resources behind
az group list --output table
Name                                                                  Location    Status
--------------------------------------------------------------------  ----------  ---------
rg-prod-backup-euw                                                    westeurope  Succeeded
rg-prod-network-euw                                                   westeurope  Succeeded
NetworkWatcherRG                                                      westeurope  Succeeded
rg-prod-ascdf-weu                                                     westeurope  Succeeded
rg-prod-translate-euw                                                 westeurope  Succeeded
rg-test-arck-rg-euw                                                   westeurope  Succeeded
MC_rg-test-arck-rg-euw_arck-rc-ikt-aks-nerdmeet-tst-euw-1_westeurope  westeurope  Succeeded

delete the resource group: MC_rg-test-arck-rg-euw_arck-rc-ikt-aks-nerdmeet-tst-euw-1_westeurope

```bash
az group delete --name MC_rg-test-arck-rg-euw_arck-rc-ikt-aks-nerdmeet-tst-euw-1_westeurope --no-wait --yes
``` 


## trying to create a private cluster
```bash
az aks create --resource-group rg-test-arck-rg-euw --name nerdkube --node-count 1 --network-plugin azure --vnet-subnet-id /subscriptions/2db70c5d-333e-478d-a6cc-df7cb1e83b30/resourceGroups/rg-test-arck-rg-euw/providers/Microsoft.Network/virtualNetworks/nerdmeet/subnets/nerdkubernetes --generate-ssh-keys --enable-private-cluster

docker_bridge_cidr is not a known attribute of class <class 'azure.mgmt.containerservice.v2024_01_01.models._models_py3.ContainerServiceNetworkProfile'> and will be ignored
(ServiceCidrOverlapExistingSubnetsCidr) The specified service CIDR 10.0.0.0/16 is conflicted with an existing subnet CIDR 10.0.1.0/24
Code: ServiceCidrOverlapExistingSubnetsCidr
Message: The specified service CIDR 10.0.0.0/16 is conflicted with an existing subnet CIDR 10.0.1.0/24
Target: networkProfile.serviceCIDR
```

Must delete it:
az aks list --resource-group rg-test-arck-rg-euw --output table

Name                                Location    ResourceGroup        KubernetesVersion    CurrentKubernetesVersion    ProvisioningState    Fqdn
----------------------------------  ----------  -------------------  -------------------  --------------------------  -------------------  --------------------------------------------------------------------
arck-rc-ikt-aks-nerdmeet-tst-euw-1  westeurope  rg-test-arck-rg-euw  1.27                 1.27.9                      Failed               arck-rc-ik-rg-test-arck-rg--2db70c-6hiu703g.hcp.westeurope.azmk8s.io

az aks delete --name arck-rc-ikt-aks-nerdmeet-tst-euw-1 --resource-group rg-test-arck-rg-euw --yes --no-wait

