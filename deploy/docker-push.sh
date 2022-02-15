#!/bin/bash

ACR_URL=$(az acr list -g wu-capp --query "[].loginServer" -o tsv)
ACR_USERNAME=$(az keyvault secret show --vault-name wu-kv --name AcrPushServicePrincipalAppId --query "value" -o tsv)
ACR_PASSWORD=$(az keyvault secret show --vault-name wu-kv --name AcrPushServicePrincipalPassword --query "value" -o tsv)

docker login $ACR_URL --username $ACR_USERNAME --password $ACR_PASSWORD
docker push "$ACR_URL/wu-capp:1"
