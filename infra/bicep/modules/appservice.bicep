param name string
param appServicePlanName string
param location string
param vnetName string
param appServiceSku string
param tags object

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServiceSku
    tier: 'Standard'
  }
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITE_VNET_ROUTE_ALL'
          value: '1'
        }
      ]
    }
  }
  tags: tags
  
}

resource appServiceVnetIntegration 'Microsoft.Web/sites/networkConfig@2020-06-01' = {
  name: '${webApp.name}/virtualNetwork'
  properties: {
    subnetResourceId: vnet.properties.subnets[0].id
  }
  dependsOn: [
    appServicePlan
    vnet
  ]
}
