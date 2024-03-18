param apimServiceName string = 'intg-apim-eus'
param swaggerURL string = 'https://raw.githubusercontent.com/terchris/nerdmeet/main/infrastructure/private-azure/swagger/testfunction.json'

resource apiVersionSet 'Microsoft.ApiManagement/service/api-version-sets@2021-08-01' = {
  name: '${apimServiceName}/testfunction-versionset'
  properties: {
    displayName: 'TEST Function API Versions'
    versioningScheme: 'Segment'
    description: 'Version set for the Test Function APIs'
  }
}

resource testFunctionApi 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${apimServiceName}/testfunction'
  properties: {
    displayName: 'TEST Function APIs'
    description: 'APIs for getting the current time and the current day of the week'
    serviceUrl: 'https://func-intg-testfunction-int001-eus-01.azurewebsites.net'
    path: 'testfunction'
    protocols: ['https']
    apiVersion: 'v1'
    apiVersionSetId: apiVersionSet.id
    format: 'swagger-link-json'
    value: swaggerURL
  }
}
