#!/bin/bash

cd $(dirname $0)

PREFIX=wu-az-capp
RESOURCE_GROUP=$PREFIX

if [[ $(az group exists --resource-group $RESOURCE_GROUP) = false ]]; then
    echo "Resource group $RESOURCE_GROUP doesn't exist!"
    exit 1
fi

az deployment group create \
    --resource-group $RESOURCE_GROUP \
    --template-file main.bicep \
    --parameters \
        prefix=$PREFIX
