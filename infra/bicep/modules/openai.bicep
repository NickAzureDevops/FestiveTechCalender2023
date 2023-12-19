param name string

param location string = resourceGroup().location
param tags object = {}
@allowed([
  'S0'
])
param sku string = 'S0'


resource openAI 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
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


output cognitiveServiceName string = openAI.name
output cognitiveServiceId string = openAI.id
output cognitiveServiceEndpoint string = openAI.properties.endpoint
