param name string
param location string = resourceGroup().location
param tags object = {}
@allowed([
  'S0'
])
param sku string = 'S0'
param models array

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
    customSubDomainName: name
  }
}

@batchSize(1)
resource modelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2022-12-01' = [for model in models: {
  name: model.name
  parent: cognitiveService
  properties: {
    model: {
      format: 'OpenAI'
      name: model.name
      version: model.version
    }
    scaleSettings: {
      scaleType: contains(model, 'scaleType') && !empty(model.scaleType) ? model.scaleType : 'Standard'
    }
  }
}]

output cognitiveServiceName string = cognitiveService.name
output cognitiveServiceId string = cognitiveService.id
output cognitiveServiceEndpoint string = cognitiveService.properties.endpoint
