# nerdnet firewall

## Firewall functionality

We are using Azure Application Gateway as a firewall. The Application Gateway is the only resource with a public IP address. The Application Gateway terminates SSL and routes traffic based on subdomain.

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

Documentation on how the Application Gateway is set up is in the file [14cmd-application-gateway](./14cmd-application-gateway.md).

## External IP address

| IP address         |
| ------------------ |
| 23.96.119.221      |

## SSL termination

The Application Gateway terminates SSL and routes traffic based on subdomain.
The following domains are routed to the firewall:

| Domain             | Certificate name                  |
| ------------------ | --------------------------------- |
| *.christensen.no   | christensen-ssl-cert              |

Documentation on how to get a SSL certificate in the file [Create SSL certificate](3ssl-create.md).

## Firewall rules

Documentation on how the firewall rules are set up is [in this file](15cmd-firewall-config.md). (Initial setup for vm1 in the nerd landing zone)


### Frontend ports

Frontend ports define the port's the Application Gateway listens to.

| Frontend IP name                         | Port |
| ---------------------------- | ---- |
| appGatewayFrontendPort       | 80   |
| appGatewayHttpsFrontendPort  | 443  |

### Listeners

Listeners define witch Frontend IP name's the Application Gateway listens to.

| Listener Name | Protocol | Frontend IP name |
| ------------- | -------- | ----------- |
| appGatewayHttpListener | http | appGatewayFrontendPort |
| appGatewayHttpsListener | https | appGatewayHttpsFrontendPort |


### Address pools

Name, Landing Zone, IP address
| Address pool name | Landing Zone | IP address |
| --------- | ------------ | ---------- |
| vm1-nerd-ip-pool | nerd         | 10.21.1.4  |

### HTTP Listeners

| HTTP Listener name |  Host name | Frontend port | Frontend IP name | Comment |
| ------------------ |  --------- | ------------- | ---------------- | ------- |
| vm1-http-listener  | vm1.christensen.no | appGatewayFrontendPort | appGatewayFrontendIP | the http listener rule for vm1 |
| vm1-https-listener | vm1.christensen.no | appGatewayHttpsFrontendPort | appGatewayHttpsFrontendIP | the https listener rule for vm1 |

### Rules

Rule name, HTTP Listener name, Address pool name, Priority
| Rule name | HTTP Listener name | Address pool name | Priority |
| --------- | ------------------ | ----------------- | -------- |
| rule-vm1-http | vm1-http-listener | vm1-nerd-ip-pool | 100 |
| rule-vm1-https | vm1-https-listener | vm1-nerd-ip-pool | 110 |


TODO: Add the rules for the other landing zones.