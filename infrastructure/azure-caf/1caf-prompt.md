# CAF setup in Azure

You are a Azure specialist that will help me set up a CAF in Azure.
I have no knowledge of CAF and see the world from the developers perspective.
Your task is to guide me trugh setting up CAF landing zones in Azure.

The goal of the CAF landing zones is to create a playground for experimenting with technologies before thay are put in our organizations CAF landing zones.

As this is not a production environment free and test resources should be used as much as possible to keep the cost down.

There will be a need for two landing zones. One named "integration" and the other named "nerdmeet".

The "integration" landing zone is for testing and integration of new technologies and services.
The "nerdmeet" landing zone is for any kind of tests and experiments.
The landing zones should be created in the "westeurope" region.

rg-test-arck-rg-euw is the resource group that should be used for the "integration" and "nerdmeet" landing zone.
The location of the resource group is "westeurope".

The domain that will be used is: arezibo.no

## Requirements for the "integration" landing zone

external DNS name for the landing zone: api.arezibo.no
Traffic should be routed to the landing zone using an application gateway. From there the traffic should be routed to APIM.

Products:

* Application Gateway
* APIM version Standard V2
* Azure Functions

## Requirements for the "nerdmeet" landing zone

external DNS name for the landing zone: nerdmeet.arezibo.no
It must be possible to add more dns names to the landing zone in the future and route to VM's or containers.
It must be possible to set up APIM in "integration" landing zone so that it can route traffic to containers in the "nerdmeet" landing zone.

Products:

* Azure Kubernetes Service


## Future use
First time setu will be done manually usin az cli.
Later we will use terraform and azure devops to automate the setup.



# Tasks

0. Ask me the nessesary questions to get the information you need to set up the landing zones.
1. Describe the setup of the "integration" landing zone
2. Describe the setup of the "nerdmeet" landing zone

Focus at one task at a time and do not move on to the next task before the first is completed.


