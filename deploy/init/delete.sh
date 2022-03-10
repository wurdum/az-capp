#!/bin/bash

PREFIX=wu-az-capp
RESOURCE_GROUP=$PREFIX

if [[ $(az group exists --resource-group $RESOURCE_GROUP) = false ]]
then
    echo "Resource group $RESOURCE_GROUP is already deleted!"
else
    echo "Deleting resource group $RESOURCE_GROUP..."
    az group delete -y -n $RESOURCE_GROUP
    echo "Done"
fi

echo "Deleting Budget..."
az consumption budget delete --budget-name $RESOURCE_GROUP-budget
echo "Done"

echo "Deleting Service Principals $RESOURCE_GROUP..."
az ad sp list --filter "startswith(displayname, '$RESOURCE_GROUP')" --query "[].objectId" --output tsv | xargs -t -I{} az ad sp delete --id {}
echo "Done"
