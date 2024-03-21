# NerdMeet
We help the helpers.
NerdMeet is a community for nerds that use technology to help people in need. At the same time we meet, share and learn new technologies.

The community is built on the following principles:

* We belive that technology can help people in need.
* We are eager to share what we know.
* We want to learn from others in the community.
* We are not selling anything to each other.
* We meet one a month after work hours.

## NerdNet playgorund

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

nerdnet is our playground for testing new technologies. nerdnet is running on a sponsored Azure subscription.

We are looking for funding to keep the subscription running.


Playgroud setup:
| Landing Zone | Long name | Description |
|--------------|------------|-------------|
| api          | api        | For testing API managemet and Azure Functions |
| nerd     | nerdmeet       | Different VMs. for running AI and other fun stuff |
| k8s   | kubernetes        | Kubernetes cluster for testing |


If you want to create your own playground. You can just fork this repo and then you just follow the documentation to set it up.
Your testing an playing will for sure create new knowledege - please share it with the community.

Read the [readme.md](nerdnet/readme.md) for more information about the network and the resources.
