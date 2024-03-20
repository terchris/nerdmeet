# nerdnet network

This is the current description of the nerdnet network. For a conseptual overview of the network see [7concept-network-architecture-security.md](7concept-network-architecture-security.md).


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

* Landing Zone: api, api for short.
* Landing Zone: nerdmeet, nerd for short.
* Landing Zone: kubernetes, k8s for short.

The landing zone api is set up for testing Azure API Management and Azure Functions.

The landing zone nerdmeet is set up for testing AI and different VMs.

The landing zone kubernetes is set up for testing kubernetes.

In front of all landing zones there is an Application Gateway. The Application Gateway terminates SSL and routes traffic based on subdomain. The Application Gateway is the only resource with a public IP address.

DNS *.christensen.no is pointing to the public IP address of the Application Gateway.
