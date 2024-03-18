param apimServiceName string = 'intg-apim-eus'
param swaggerURL string = 'https://raw.githubusercontent.com/terchris/nerdmeet/main/infrastructure/private-azure/swagger/testfunction.json'

resource testFunctionApi 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${apimServiceName}/testfunction'
  properties: {
    displayName: 'Test Function APIs'
    description: 'APIs for getting the current time and the current day of the week'
    serviceUrl: 'https://func-intg-testfunction-int001-eus-01.azurewebsites.net'
    path: 'testfunction/v1'
    protocols: ['https']
    format: 'swagger-link-json'
    value: swaggerURL
  }
}
