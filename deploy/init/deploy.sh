#!/bin/bash

cd $(dirname $0)

PREFIX=wu
LOCATION=westeurope
RESOURCE_GROUP=wu-capp
SERVICE_PRINCIPAL_NAME=$RESOURCE_GROUP-sp

if [[ $(az group exists --resource-group $RESOURCE_GROUP) = true ]]; then
    echo "Resource group $RESOURCE_GROUP is already exist!"
    exit 1
fi

if [[ -z $WU_ADMIN_SERVICE_PRINCIPAL_OBJECT_ID ]]; then
    echo "Environment variable WU_ADMIN_SERVICE_PRINCIPAL_OBJECT_ID is not set!"
    exit 1
fi

RESOURCE_GROUP_ID=$(az group create --name $RESOURCE_GROUP --location $LOCATION --query "id" --output tsv)

az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME-gh --role owner --scopes $RESOURCE_GROUP_ID
echo "Use the JSON above to set AZURE_CREDENTIALS GitHub Secret"

READ_KV_SERVICE_PRINCIPAL_PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME-kv-read --query "password" --output tsv)
READ_KV_SERVICE_PRINCIPAL_OBJECT_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME-kv-read --query "[].objectId" --output tsv)
READ_KV_SERVICE_PRINCIPAL_APP_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME-kv-read --query "[].appId" --output tsv)

ACR_PUSH_SERVICE_PRINCIPAL_PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME-acr-push --query "password" --output tsv)
ACR_PUSH_SERVICE_PRINCIPAL_OBJECT_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME-acr-push --query "[].objectId" --output tsv)
ACR_PUSH_SERVICE_PRINCIPAL_APP_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME-acr-push --query "[].appId" --output tsv)

ACR_PULL_SERVICE_PRINCIPAL_PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME-acr-pull --query "password" --output tsv)
ACR_PULL_SERVICE_PRINCIPAL_OBJECT_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME-acr-pull --query "[].objectId" --output tsv)
ACR_PULL_SERVICE_PRINCIPAL_APP_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME-acr-pull --query "[].appId" --output tsv)

az deployment group create \
    --resource-group $RESOURCE_GROUP \
    --template-file main.bicep \
    --parameters \
        prefix=$PREFIX \
        adminServicePrincipalObjectId=$WU_ADMIN_SERVICE_PRINCIPAL_OBJECT_ID \
        readKvServicePrincipalObjectId=$READ_KV_SERVICE_PRINCIPAL_OBJECT_ID \
        readKvServicePrincipalAppId=$READ_KV_SERVICE_PRINCIPAL_APP_ID \
        readKvServicePrincipalPassword=$READ_KV_SERVICE_PRINCIPAL_PASSWORD \
        acrPushServicePrincipalObjectId=$ACR_PUSH_SERVICE_PRINCIPAL_OBJECT_ID \
        acrPushServicePrincipalAppId=$ACR_PUSH_SERVICE_PRINCIPAL_APP_ID \
        acrPushServicePrincipalPassword=$ACR_PUSH_SERVICE_PRINCIPAL_PASSWORD \
        acrPullServicePrincipalObjectId=$ACR_PULL_SERVICE_PRINCIPAL_OBJECT_ID \
        acrPullServicePrincipalAppId=$ACR_PULL_SERVICE_PRINCIPAL_APP_ID \
        acrPullServicePrincipalPassword=$ACR_PULL_SERVICE_PRINCIPAL_PASSWORD
