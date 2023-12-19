param name string
param location string = resourceGroup().location
param tags object = {}
param createMode string = 'default'
param cognitiveServiceName string
param softDeleteRetentionInDays int = 90
@allowed([
  'standard'
  'premium'
])
param sku string = 'standard'

param networkAcls object = {
  defaultAction: 'Allow'
  bypass: 'AzureServices'
}

resource vault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    createMode: createMode
    accessPolicies: [
    ]
    enableRbacAuthorization: false
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
    sku: {
      name: sku
      family: 'A'
    }
    networkAcls: networkAcls
  }
}

var keys = listKeys(resourceId(resourceGroup().name, 'Microsoft.CognitiveServices/accounts', cognitiveServiceName), '2022-12-01')

resource openAiKey1 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: vault
  name: 'openai-key-1'
  properties: {
    value: keys.key1
  }
}
resource openAiKey2 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: vault
  name: 'openai-key-2'
  properties: {
    value: keys.key2
  }
}
