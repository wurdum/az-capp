#!/bin/bash

PREFIX=wu-az-capp
RESOURCE_GROUP=$PREFIX

ACR_URL=$(az acr list -g $RESOURCE_GROUP --query "[].loginServer" -o tsv)
ACR_USERNAME=$(az keyvault secret show --vault-name $PREFIX-kv --name AcrPushServicePrincipalAppId --query "value" -o tsv)
ACR_PASSWORD=$(az keyvault secret show --vault-name $PREFIX-kv --name AcrPushServicePrincipalPassword --query "value" -o tsv)

docker login $ACR_URL --username $ACR_USERNAME --password $ACR_PASSWORD
docker build -t $PREFIX-http:$(date +%s) -t $PREFIX-http:latest -f src/AzCappHttp/Dockerfile .
docker push $ACR_URL/wu-az-capp-http --all-tags
