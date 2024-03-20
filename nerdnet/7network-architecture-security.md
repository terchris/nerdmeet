# Network Architecture and security 

nerdnet uses ideas from CAF 

Internet traffic can only enter the network at one point,  the firewall. 


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


We use the concept of landing zones defined in CAF to describe these segments. 

In practice each landing zone has a subnet. 

