param name string
param location string = resourceGroup().location

resource environment 'Microsoft.Web/kubeEnvironments@2021-02-01' = {
  name: name
  location: location
  properties: {
    internalLoadBalancerEnabled: false
    appLogsConfiguration: {    
    }
  }
}
output id string = environment.id

resource containerApp 'Microsoft.App/containerApps@2022-03-01' ={
  name: name
  location: location
  properties:{
    managedEnvironmentId: environment.id
    configuration: {
      ingress: {
        targetPort: 80
        external: true
      }
    }
    template: {
      containers: [
        {
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          name: 'simple-hello-world-container'
        }
      ]
    }
  }
}

output location string = location
output environmentId string = environment.id

