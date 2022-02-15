param prefix string
param tags object

param location string = resourceGroup().location

resource logs 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: '${prefix}-logs'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource env 'Microsoft.Web/kubeEnvironments@2021-02-01' = {
  name: '${prefix}-env'
  location: location
  tags: tags
  kind: 'containerenvironment'
  properties: {
    type: 'managed'
    internalLoadBalancerEnabled: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logs.properties.customerId
        sharedKey: logs.listKeys().primarySharedKey
      }
    }
  }
}
