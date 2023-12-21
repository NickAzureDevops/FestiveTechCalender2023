param name string 
param location string
param sku string = 'basic'

resource search 'Microsoft.Search/searchServices@2022-09-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    publicNetworkAccess: 'disabled'
  }
}
