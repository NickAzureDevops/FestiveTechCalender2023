param name string

param location string = resourceGroup().location
param tags object = {}
@allowed([
  'S0'
])
param sku string = 'S0'


resource cognitiveService 'Microsoft.CognitiveServices/accounts@2022-12-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  kind: 'OpenAI'
  properties: {
    restore: false
    customSubDomainName: toLower(name)
    publicNetworkAccess: 'disabled'
    }
  }


output cognitiveServiceName string = cognitiveService.name
output cognitiveServiceId string = cognitiveService.id
output cognitiveServiceEndpoint string = cognitiveService.properties.endpoint
