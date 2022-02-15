param prefix string
param tags object
param tenantId string
param secrets array
param adminServicePrincipalId string
param readServicePrincipalId string

param location string = resourceGroup().location

resource kv 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: '${prefix}-kv'
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    enableSoftDelete: false
    enabledForTemplateDeployment: true
    accessPolicies: [
      {
        objectId: adminServicePrincipalId
        tenantId: tenantId
        permissions: {
          certificates: [
            'all'
          ]
          keys: [
            'all'
          ]
          storage: [
            'all'
          ]
          secrets: [
            'all'
          ]
        }
      }
      {
        objectId: readServicePrincipalId
        tenantId: tenantId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = [for secret in secrets: {
  name: secret.name
  parent: kv
  properties: {
    value: secret.value
  }
}]
