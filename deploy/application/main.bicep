targetScope = 'resourceGroup'

param prefix string
param location string = resourceGroup().location

var tags = {
  Project: resourceGroup().name
}

resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: '${prefix}-kv'
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: '${replace(prefix, '-', '')}acr${uniqueString(resourceGroup().id)}'
}

resource kenv 'Microsoft.Web/kubeEnvironments@2021-03-01' existing = {
  name: '${prefix}-env'
}

module cappHttp 'capp-http.bicep' = {
  name: 'az-capp-http'
  params: {
    prefix: prefix
    location: location
    tags: tags

    kubeEnvironmentId: kenv.id

    acrServer: acr.properties.loginServer
    acrUsername: kv.getSecret('AcrPullServicePrincipalAppId')
    acrPassword: kv.getSecret('AcrPullServicePrincipalPassword')

    imageName: '${prefix}-http'
    imageTag: 'latest'
    ingressPort: 5555
  }
}
