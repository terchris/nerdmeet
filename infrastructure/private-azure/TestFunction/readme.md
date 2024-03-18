# TestFunction


Test function app for Azure Functions

Contains two functions:
- TimeFunction - returns the current time
- DayOfWeekFunction - returns the current day of the week

The functions will be implemented in JavaScript for simplicity.

 [Learn more about running functions locally here:](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local)

## Prerequisites

### install the tools on mac
```bash
brew tap azure/functions
brew install azure-functions-core-tools@4
```

## Create the function app

```bash
func init TestFunction --worker-runtime node --language javascript
```

You will get the following output:

```text
The new Node.js programming model is generally available. Learn more at https://aka.ms/AzFuncNodeV4
Writing package.json
Writing .funcignore
Writing .gitignore
Writing host.json
Writing local.settings.json
Writing /Users/terchris/learn/projects-2024/nerdmeet/infrastructure/private-azure/TestFunction/.vscode/extensions.json
```

## Create the functions

Change to the directory TestFunction and create the functions

```bash
func new --name TimeFunction --template "HTTP trigger" --authlevel anonymous

func new --name DayOfWeekFunction --template "HTTP trigger" --authlevel anonymous
```

I have added the code to the functions. So now you can run the functions locally.

First install dependencies

```bash
npm install
```

Then run the functions locally

```bash
func start
```

You should see the following output:

```text
Azure Functions Core Tools
Core Tools Version:       4.0.5571 Commit hash: N/A +9a5b604f0b846df7de3eb37b423a9eba8baa1152 (64-bit)
Function Runtime Version: 4.30.0.22097

[2024-03-17T10:26:19.014Z] Worker process started and initialized.

Functions:

        DayOfWeekFunction: [GET] http://localhost:7071/api/DayOfWeekFunction

        TimeFunction: [GET] http://localhost:7071/api/TimeFunction

For detailed output, run func with --verbose flag.
[2024-03-17T10:26:23.974Z] Host lock lease acquired by instance ID '000000000000000000000000E86A40EB'.
```

You can now test the functions by opening a browser and navigating to the following URLs:

* http://localhost:7071/api/DayOfWeekFunction
* http://localhost:7071/api/TimeFunction

## Deploy the function app to Azure

Here we assume that you have a function app in Azure that is named `func-intg-testfunction-int001-eus-01`.
To use the func tool you can do:

```bash
func azure functionapp publish func-intg-testfunction-int001-eus-01
```
