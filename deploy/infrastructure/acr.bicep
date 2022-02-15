param prefix string
param tags object

@secure()
param pullPrincipalId string
@secure()
param pushPrincipalId string

param location string = resourceGroup().location
param acrSku string = 'Basic'

resource acrResource 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: '${prefix}acr${uniqueString(resourceGroup().id)}'
  location: location
  tags: tags
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
  }
}

resource acrPushRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '8311e382-0749-4cb8-b61a-304f252e45ec'
}

resource pushRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(resourceGroup().id, pushPrincipalId, acrPushRoleDefinition.id)
  scope: acrResource
  properties: {
    principalId: pushPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: acrPushRoleDefinition.id
  }
}

resource acrPullRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
}

resource pullRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(resourceGroup().id, pullPrincipalId, acrPullRoleDefinition.id)
  scope: acrResource
  properties: {
    principalId: pullPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: acrPullRoleDefinition.id
  }
}

output loginServer string = acrResource.properties.loginServer
