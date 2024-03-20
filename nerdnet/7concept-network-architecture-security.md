# Concepts Network Architecture and security

nerdnet uses ideas from Microsot CAF (Cloud Adoption Framework) to define the network architecture.

Internet traffic can only enter the network at one point, the firewall.

## Conseptual architecture

```mermaid
graph LR;
 client([client])-. web or API <br> request .->ingress[Firewall];
 ingress-->|routing rule|service[dispatcher?];
 subgraph Firewall functionality
 ingress;
 service-->pod1[Network segment];
 service-->pod2[network segment];
 service-->pod3[Network segment];
 end
 classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
 classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
 classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
 class ingress,service,pod1,pod2,pod3 k8s;
 class client plain;
 class cluster cluster;
 ```

The nerdnet is segmented so that resources that needs to communicate are in the same segment.
This means that resources in one segment cannot communicate with resources in another segment without spec definition.

```mermaid
graph TB
   subgraph "segmentB"
       n3(System1)
       n4(System2)
   end
   subgraph "segmentA"
       n1(SystemA)
       n2(SystemB)
   end
 
   classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
   classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
   classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
   class n1,n2,n3,n4 k8s;
   class zoneA,zoneB cluster;
```

System1 can communicate with System2 but not with SystemA or SystemB.

## Azure network architecture

Conceptual architecture of the network in Azure.

```mermaid
graph LR;
 client([client])-. web or API <br> request .->ingress[Azure Application Gateway];
 ingress-->|routing rule|service[dispatcher?];
 subgraph Firewall functionality
 ingress;
 service-->pod1[Landing zone 1];
 service-->pod2[Landing zone 2];
 service-->pod3[Landing zone 3];
 end
 classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
 classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
 classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
 class ingress,service,pod1,pod2,pod3 k8s;
 class client plain;
 class cluster cluster;
 ```

Using CAF terminology we can define the network architecture in terms of landing zones.

```mermaid
graph TB
   subgraph "Landing zone 1"
       n1(SystemA)
       n2(SystemB)
   end
   subgraph "Landing zone 2"
       n3(System1)
       n4(System2)
   end
    subgraph "Landing zone 3"
       n3(System1)
       n4(System2)
   end
   classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
   classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
   classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
   class n1,n2,n3,n4 k8s;
   class zone1,zone2 cluster;
```

For info about the [Azure cloud resources we use se the file cloud-azure.md](./5cloud-azure.md)




If you look at the world from a network infrastructure perspective then you can think of Landing Zones as subnets.
