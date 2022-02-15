targetScope = 'resourceGroup'

param prefix string
param location string = resourceGroup().location

var tags = {
  Project: resourceGroup().name
}

resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: '${prefix}-kv'
}

module acr './acr.bicep' = {
  name: 'acr'
  params: {
    prefix: prefix
    location: location
    tags: tags
    pullPrincipalId: kv.getSecret('AcrPullServicePrincipalObjectId')
    pushPrincipalId: kv.getSecret('AcrPushServicePrincipalObjectId')
  }
}

module kenv './kenv.bicep' = {
  name: 'kenv'
  params: {
    prefix: prefix
    location: location
    tags: tags
  }
}
