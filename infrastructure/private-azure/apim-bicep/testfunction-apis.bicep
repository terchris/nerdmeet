param apimServiceName string = 'intg-apim-eus'
param swaggerURL string = 'https://raw.githubusercontent.com/terchris/nerdmeet/main/infrastructure/private-azure/swagger/testfunction.json'

// Define the API in Azure API Management
resource testFunctionApi 'Microsoft.ApiManagement/service/apis@2023-05-01-preview' = {
  name: '${apimServiceName}/testfunction'
  properties: {
    displayName: 'TesT Function APIs'
    description: 'APIs for DayOfWeekFunction and TimeFunction, exposed through APIM'
    serviceUrl: 'https://func-intg-testfunction-int001-eus-01.azurewebsites.net'
    path: 'testfunction' // This should match the basePath in your Swagger file minus the leading slash
    protocols: ['https']
    format: 'swagger-link-json'
    value: swaggerURL
  }
}
