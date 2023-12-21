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

var subnetName = 'general'
var openAIPepSubnetName = 'openai-pep-subnet'
var appServiceSku = 'S1'
module vnet 'modules/vnet.bicep' = {
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    vnetName: 'vnet-${environment}-${project}-${suffix}'
    location: location
    subnetname: subnetName
    openAIPepsubnetname: openAIPepSubnetName
    tags: tags
  }
}

module openai 'modules/openai.bicep' = {
  name: 'openai-${environment}-${project}-${suffix}'
  params: {
    name: 'openai-${environment}-${project}-${suffix}'
    location: location
    tags: tags
  }
}

module openAIPrivateEndpoint 'modules/openai_private_endpoint.bicep' = {
  name: 'openai-pep-${environment}-${project}-${suffix}'
  params: {
    name: openai.name
    location: location
    privateEndpointOpenAIName: 'openai-pep-${environment}-${project}-${suffix}'
    openAISubnetName: openAIPepSubnetName
    vnetName: vnet.outputs.vnetname
    virtualNetworkId: openAIVirtualNetworkLinkName
    tags: tags
  }
}

module appservice './modules/appservice.bicep' = {
  name: 'app-${environment}-${project}-${suffix}'
  params: {
    name: 'app-${environment}-${project}-${suffix}'
    location: location
    tags: tags
    vnetName: vnet.outputs.vnetname
    appServicePlanName: 'appserviceplan-${environment}-${project}-${suffix}'
    appServiceSku: appServiceSku
  }
}
