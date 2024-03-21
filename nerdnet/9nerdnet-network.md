# nerdnet network

In front of all landing zones there is an Application Gateway. The Application Gateway terminates SSL and routes traffic based on subdomain. The Application Gateway is the only resource with a public IP address.


## Landing Zones

```mermaid
graph LR
   Firewall(Firewall)
   
   subgraph "k8s"
       subgraph "AKSCluster"
       aks(AKS) 
       nginx(nginx)
       end
   end
   subgraph "api"
       apim(APIM)
       subgraph "AzureFunctions"
       testfunction(testfunction)
       end
   end
    subgraph "nerd"
       vm01(vm01)
   end

   classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
   classDef activeVM fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
   classDef controller fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
   classDef zone fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
   classDef groupCluster fill:#e8f0fe,stroke:#bbb,stroke-width:2px,color:#000; 
   classDef groupFunction fill:#e8f0fe,stroke:#bbb,stroke-width:2px,color:#000; 

   class vm01 activeVM;
   class apim,aks controller;
   class nerd,k8s,api zone;
   class AKSCluster groupCluster;
   class AzureFunctions groupFunction;

   Firewall --> apim
   Firewall --> aks
   Firewall --> vm01
   apim -.-> testfunction
   aks -.-> nginx
```

The landing zones are:

| Landing Zone | Long name | Description |
|--------------|------------|-------------|
| api          | api        | Azure API Management and Azure Functions |
| nerd     | nerdmeet       | AI and different VMs |
| k8s   | kubernetes        | Kubernetes cluster |

Documentation on how to set up the landing zones can be found in the [Application Gateway](14cmd-application-gateway.md) folder.

## Network info

### VNET

| Virtual Network | Address Space |
|-----------------|---------------|
| vnet-eus        | 10.21.0.0/16  |

### Subnets

| Subnet | Address Space | Comment |
|--------|---------------|---------|
| appgw-backend-sn01-eus | 10.21.0.0/24 | Application Gateway |
| nerd-backend-sn01-eus | 10.21.1.0/24 | nerd (nerdmeet)  |
| k8s-backend-sn01-eus | 10.21.2.0/24 | k8s (kubernetes) |
| api-backend-sn01-eus | 10.21.3.0/24 | api (Azure API Management and Azure Functions) |

Doc on how set up the landing zones can be found in [Network Landing Zones](13cmd-network-landingzones.md).

This is the current description of the nerdnet network. For a conseptual overview of the network see [7concept-network-architecture-security.md](7concept-network-architecture-security.md).

## Firewall documentation

Firewall documentation can be found in [nerdnet-firewall](10nerdnet-firewall.md).
