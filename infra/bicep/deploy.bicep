param environment string = 'dev'
param project string = 'privatechatbot'
param location string = 'westeurope'
param suffix string = '01'
param tags object = {
  project: 'festivetechcalender'
  environment: 'dev'
  department: 'platform'
}

@description('The name of the virtual network link')
param openAIVirtualNetworkLinkName string = '${uniqueString(resourceGroup().id)}-virtualnetworklink'
param openAIPrivateEndpointName string = '${uniqueString(resourceGroup().id)}-openai-privateendpoint'


var vnetName = 'chatgptvnet01'
var subnetName = 'chatgpt-subnet'
var cogSearchPepSubnetName = 'cogpesubnet'
var openAIPepSubnetName = 'openai-pep-subnet'

module vnet 'modules/vnet.bicep' = {
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    vnetName: 'vnet-${environment}-${project}-${suffix}'
    location: location
    subnetName: subnetName
    pepSubnetName: cogSearchPepSubnetName
    openAIPepSubnetName: openAIPepSubnetName
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
  name: '${uniqueString(deployment().name, location)}-openai'
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
    vnetName: vnetName
    virtualNetworkId: openAIVirtualNetworkLinkName
  }
}
