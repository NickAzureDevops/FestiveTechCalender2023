param environment string = 'dev'
param project string = 'privatechatbot'
param location string = resourceGroup().location
param suffix string = '01'
param tags object = {
  project: 'festivetechcalender'
  environment: 'dev'
  department: 'platform'
}

@description('The name of the virtual network link')
param openAIVirtualNetworkLinkName string = 'festivetechcalender-virtualnetworklink'
param openAIPrivateEndpointName string = 'openai-privateendpoint'

param openAIName string = 'privatechatbot-openai'


var subnetName = 'chatgpt-subnet'
var cogSearchPepSubnetName = 'cogpesubnet'
var openAIPepSubnetName = 'openai-pep-subnet'

module vnet 'modules/vnet.bicep' = {
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    vnetName: 'vnet-${environment}-${project}-${suffix}'
    location: location
    subnetname: subnetName
    pepsubnetname: cogSearchPepSubnetName
    openAIPepsubnetname: openAIPepSubnetName
  }
}

module vault 'modules/keyvault.bicep' = {
  name: '${uniqueString(deployment().name, location)}-vault'
  params: {
    name: 'kv-${environment}-${project}-${suffix}'
    location: location
    tags: tags
    cognitiveServiceName: openai.outputs.cognitiveServiceName
  }
}


module openai 'modules/openai.bicep' = {
  name: openAIName
  params: {
    name: 'openai-${environment}-${project}-${suffix}'
    location: location
    tags: tags
  }
}

module openAIPrivateEndpoint 'modules/openai_private_endpoint.bicep' = {
  name: openAIPrivateEndpointName
  params: {
    name: openai.name
    location: location
    privateEndpointOpenAIName: openAIPrivateEndpointName
    openAISubnetName: openAIPepSubnetName
    vnetName: vnet.outputs.vnetname
    virtualNetworkId: openAIVirtualNetworkLinkName
  }
}

