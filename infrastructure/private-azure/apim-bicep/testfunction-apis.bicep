param apimServiceName string = 'intg-apim-eus'
param swaggerURL string = 'https://raw.githubusercontent.com/terchris/nerdmeet/main/infrastructure/private-azure/swagger/testfunction.json'

resource testFunctionApi 'Microsoft.ApiManagement/service/apis@2023-05-01-preview' = {
  name: '${apimServiceName}/testfunction'
  properties: {
    displayName: 'TEST Function APIs'
    description: 'APIs for DayOfWeekFunction and TimeFunction'
    serviceUrl: 'https://func-intg-testfunction-int001-eus-01.azurewebsites.net'
    path: 'testfunction'
    protocols: ['https']
    format: 'swagger-link-json'
    value: swaggerURL
  }
}
