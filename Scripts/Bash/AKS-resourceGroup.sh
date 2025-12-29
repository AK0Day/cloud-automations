#!/bin/bash

# This script creates a resource group for AKS (Azure Kubernetes Service) in Azure.

[ $# -ne 3 ] && echo "Usage: $(basename "$0") resourceGroup AKS_Name Region" && exit 1

resourceGroup=$1
AKS_Name=$2
region=$3

# Create the resource group
az group create --name $resourceGroup --location $region
if [ $? -ne 0 ]; then
    echo "Failed to create resource group $resourceGroup in region $region"
    exit 1
fi
echo "Resource group $resourceGroup created successfully in region $region"

# Create the AKS cluster
az aks create \
--resource-group $resourceGroup \
--name $AKS_Name \
--node-count 2 \
--node-vm-size standard_d2s_v3 \
--enable-managed-identity \
--network-plugin azure \
--generate-ssh-keys

if [ $? -ne 0 ]; then
    echo "Failed to create AKS cluster $AKS_Name in resource group $resourceGroup"
    exit 1
fi
echo "AKS cluster $AKS_Name created successfully in resource group $resourceGroup"
