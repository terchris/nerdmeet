param apimServiceName string = 'intg-apim-eus'
param dayOfWeekFunctionApiName string = 'dayofweekfunction'
param timeFunctionApiName string = 'timefunction'

resource dayOfWeekFunctionPolicy 'Microsoft.ApiManagement/service/apis/policies@2021-04-01-preview' = {
  name: '${apimServiceName}/${dayOfWeekFunctionApiName}/policy'
  properties: {
    format: 'xml'
    value: '''<policies>
                <inbound>
                  <base />
                  <set-backend-service base-url="https://func-intg-testfunction-int001-eus-01.azurewebsites.net/api/dayofweekfunction" />
                  <cors>
                    <allowed-origins>
                      <origin>*</origin>
                    </allowed-origins>
                    <allowed-methods>
                      <method>GET</method>
                      <method>POST</method>
                    </allowed-methods>
                  </cors>
                </inbound>
                <backend>
                  <base />
                </backend>
                <outbound>
                  <base />
                </outbound>
                <on-error>
                  <base />
                </on-error>
              </policies>'''
  }
}

resource timeFunctionPolicy 'Microsoft.ApiManagement/service/apis/policies@2021-04-01-preview' = {
  name: '${apimServiceName}/${timeFunctionApiName}/policy'
  properties: {
    format: 'xml'
    value: '''<policies>
                <inbound>
                  <base />
                  <set-backend-service base-url="https://func-intg-testfunction-int001-eus-01.azurewebsites.net/api/timefunction" />
                  <cors>
                    <allowed-origins>
                      <origin>*</origin>
                    </allowed-origins>
                    <allowed-methods>
                      <method>GET</method>
                      <method>POST</method>
                    </allowed-methods>
                  </cors>
                </inbound>
                <backend>
                  <base />
                </backend>
                <outbound>
                  <base />
                </outbound>
                <on-error>
                  <base />
                </on-error>
              </policies>'''
  }
}
