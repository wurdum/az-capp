param prefix string
param tags object

param kubeEnvironmentId string

param acrServer string
@secure()
param acrUsername string
@secure()
param acrPassword string

param imageName string
param imageTag string
param ingressPort int

param location string = resourceGroup().location
var containerRegistryPasswordSecretName = 'container-registry-password'

resource containerApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: '${prefix}-app'
  kind: 'containerapp'
  location: location
  tags: tags
  properties: {
    kubeEnvironmentId: kubeEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: ingressPort
      }
      secrets: [
        {
          name: containerRegistryPasswordSecretName
          value: acrPassword
        }
      ]
      registries: [
        {
          server: acrServer
          username: acrUsername
          passwordSecretRef: containerRegistryPasswordSecretName
        }
      ]
    }
    template: {
      containers: [
        {
          image: '${acrServer}/${imageName}:${imageTag}'
          name: imageName
          resources: {
            cpu: '0.25'
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 3
      }
    }
  }
}
