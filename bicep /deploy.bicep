targetScope = 'subscription'

param environment string = 'sandbox'
param project string = 'festivetechcalender2023'
param location string = 'uksouth'
param prefix string = 'chatgpt'
param suffix string = '01'
param tags object = {
  project: 'festivetechcalender2023'
  product: 'chatgpt'
  environment: 'sandbox'
  department: 'platform-engineering'
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'rg-${prefix}-${environment}-${project}-${suffix}'
  location: location
  tags: tags
}

module openai 'modules/openai.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-openai'
  params: {
    name: 'cog-${prefix}-${environment}-${project}-${suffix}'
    location: location
    tags: tags
    models: loadYamlContent('OpenAImodels.yaml')
  }
}

module vault 'modules/keyvault.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-vault'
  params: {
    name: 'kv-${prefix}-${environment}-${project}-${suffix}'
    location: location
    tags: tags
    cognitiveServiceName: openai.outputs.cognitiveServiceName
    serviceConnectionObjectId: 'd826693e-57ba-4627-994c-d7380281fd7b'
  }
}
module containerApps 'modules/containerapps.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-containerapps'
  params: {
    name: 'container-${prefix}-${environment}-${project}-${suffix}'
    location: location
    tags: tags
    openaiEndpoint: openai.outputs.endpoint
    vaultName: vault.outputs.vaultName
  }
}
