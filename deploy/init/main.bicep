targetScope = 'resourceGroup'

param prefix string

@secure()
param readKvServicePrincipalPassword string
param readKvServicePrincipalObjectId string
param readKvServicePrincipalAppId string

@secure()
param acrPullServicePrincipalPassword string
param acrPullServicePrincipalObjectId string
param acrPullServicePrincipalAppId string

@secure()
param acrPushServicePrincipalPassword string
param acrPushServicePrincipalObjectId string
param acrPushServicePrincipalAppId string

param adminServicePrincipalObjectId string
param location string = resourceGroup().location


var tags = {
  Project: resourceGroup().name
}

module kv 'kv.bicep' = {
  name: 'kv'
  params: {
    prefix: prefix
    location: location
    tags: tags
    tenantId: tenant().tenantId
    adminServicePrincipalId: adminServicePrincipalObjectId
    readServicePrincipalId: readKvServicePrincipalObjectId
    secrets: [
      {
        name: 'ReadKvServicePrincipalObjectId'
        value: readKvServicePrincipalObjectId
      }
      {
        name: 'ReadKvServicePrincipalAppId'
        value: readKvServicePrincipalAppId
      }
      {
        name: 'ReadKvServicePrincipalPassword'
        value: readKvServicePrincipalPassword
      }
      {
        name: 'AcrPushServicePrincipalObjectId'
        value: acrPushServicePrincipalObjectId
      }
      {
        name: 'AcrPushServicePrincipalAppId'
        value: acrPushServicePrincipalAppId
      }
      {
        name: 'AcrPushServicePrincipalPassword'
        value: acrPushServicePrincipalPassword
      }
      {
        name: 'AcrPullServicePrincipalObjectId'
        value: acrPullServicePrincipalObjectId
      }
      {
        name: 'AcrPullServicePrincipalAppId'
        value: acrPullServicePrincipalAppId
      }
      {
        name: 'AcrPullServicePrincipalPassword'
        value: acrPullServicePrincipalPassword
      }
    ]
  }
}
