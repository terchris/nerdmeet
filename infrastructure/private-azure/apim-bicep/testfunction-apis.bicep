param apimServiceName string = 'intg-apim-eus'
param basePath string = 'testfunction/v1'
param functionAppUrl string = 'https://func-intg-testfunction-int001-eus-01.azurewebsites.net'

resource timeFunctionApi 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${apimServiceName}/timefunction'
  properties: {
    displayName: 'Time Function API'
    description: 'API for getting the current time'
    serviceUrl: '${functionAppUrl}/api/timefunction'
    path: '${basePath}/timefunction'
    protocols: ['https']
  }
}

resource dayOfWeekFunctionApi 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${apimServiceName}/dayofweekfunction'
  properties: {
    displayName: 'Day Of Week Function API'
    description: 'API for getting the current day of the week'
    serviceUrl: '${functionAppUrl}/api/dayofweekfunction'
    path: '${basePath}/dayofweekfunction'
    protocols: ['https']
  }
}
