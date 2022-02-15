#!/bin/bash

RESOURCE_GROUP=wu-capp

echo "Deleting resource group $RESOURCE_GROUP..."
az group delete -y -n $RESOURCE_GROUP
echo "Done"

echo "Deleting Service Principals $RESOURCE_GROUP..."
az ad sp list --filter "startswith(displayname, '$RESOURCE_GROUP')" --query "[].objectId" --output tsv | xargs -t -I{} az ad sp delete --id {}
echo "Done"
