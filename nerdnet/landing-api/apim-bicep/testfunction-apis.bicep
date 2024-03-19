param apiManagementServiceName string = 'apim-api-nerd-eus'
param apiName string = 'testFunctionApi'
param swaggerFileUrl string = 'https://raw.githubusercontent.com/terchris/nerdmeet/main/nerdnet/landing-api/swagger/testfunction.json'
param apiPath string = 'testfunction'

resource apiManagementService 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName
}

resource api 'Microsoft.ApiManagement/service/apis@2023-05-01-preview' = {
  parent: apiManagementService
  name: apiName
  properties: {
    format: 'swagger-link-json' // Corrected from contentFormat
    value: swaggerFileUrl        // Corrected from contentValue
    path: apiPath
    protocols: [
      'https'
    ]
    serviceUrl: 'https://func-api-testfunction-int001-eus-01.azurewebsites.net' // The backend service URL
  }
}

output apiId string = api.name
