#!/bin/bash

[ $# -ne 3 ] && echo "Usage: $(basename "$0") cluster_action resource_group cluster_name" && exit 1

cluster_action=$1
resource_group=$2
cluster_name=$3

# Perform Azure login using service principal
az login --service-principal -u "$AZURE_CLIENT_ID" -p "$AZURE_SECRET" --tenant "$AZURE_TENANT"
if [ $? -ne 0 ]; then
    echo "Azure login failed"
    exit 1
fi 
echo "Azure login successful"

# Start or Stop the AKS cluster based on the action
if [ "$cluster_action" == "start" ]; then
    echo "Starting AKS cluster $cluster_name in resource group $resource_group..."
    az aks start --name "$cluster_name" --resource-group "$resource_group"
elif [ "$cluster_action" == "stop" ]; then
    echo "Stopping AKS cluster $cluster_name in resource group $resource_group..."
    az aks stop --name "$cluster_name" --resource-group "$resource_group"
else
    echo "Invalid action: $cluster_action. Use 'start' or 'stop'."
    exit 1
fi
if [ $? -ne 0 ]; then
    echo "Failed to $cluster_action AKS cluster $cluster_name in resource group $resource_group"
    exit 1
fi
echo "AKS cluster $cluster_name in resource group $resource_group $cluster_action""ed successfully"