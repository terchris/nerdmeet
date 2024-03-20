# nerdnet firewall

## Firewall functionality

```mermaid
graph LR;
 client([client])-. web or API <br> request .->ingress[Azure Application Gateway];
 ingress-->|routing rule|service[dispatcher?];
 subgraph Firewall functionality
 ingress;
 service-->pod1[nerd];
 service-->pod2[api];
 service-->pod3[k8s];
 end
 classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
 classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
 classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
 class ingress,service,pod1,pod2,pod3 k8s;
 class client plain;
 class cluster cluster;
 ```
