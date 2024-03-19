# CAF setup in Azure

You are an Azure specialist who will help me set up an environment in Azure.
It is important that you follow best practices and use the Cloud Adoption Framework (CAF).
I have no knowledge of CAF and see the world from the developers' perspective.

The goal of the CAF landing zones is to create a playground for experimenting with technologies before they are put in our organization's CAF landing zones.

As this is not a production environment free test resources should be used as much as possible to keep the cost down.

All resources and configurations must be done from the command line using the Azure CLI.
Bicep must be used to describe and create the infrastructure.

I'm using a Mac and have the following installed:

* Azure CLI
* Bicep
* Visual Studio Code
* Git

The github for the project is https://github.com/terchris/nerdmeet and it is set up and working.
In the repository we store all files in the folder named nerdnet and use subfolders when needed.

The file `0overall-structure.md` contains the overall structure of the landing zones.
You should start by reading that file and use it for reference while setting up the landing zones.

Tasks:

1. Analyze the 0overall-structure.md and ask questions if something is unclear.
2. Analyze the 0overall-structure.md and create a list of tasks that need to be done to set up the landing zones. Name the tasks so that we can refer to them during the setup.
3. Focus on one task at a time and do not move on to the next task before the first is completed.