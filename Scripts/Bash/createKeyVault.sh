#!/bin/bash

[ $# -ne 3 ] && echo "Usage: $(basename "$0") VaultName resourceGroup region" && exit 1

VaultName=$1
resourceGroup=$2
region=$3

# Create the Key Vault
az keyvault create --name $VaultName --resource-group $resourceGroup --location $region
if [ $? -ne 0 ]; then
    echo "Failed to create Key Vault $VaultName in resource group $resourceGroup"
    exit 1
fi
echo "Key Vault $VaultName created successfully in resource group $resourceGroup"  

# Set access policies (example: granting current user full access)
currentUser=$(az ad signed-in-user show --query userPrincipalName -o tsv)
az keyvault set-policy --name $VaultName --upn $currentUser --secret-permissions get list set delete
if [ $? -ne 0 ]; then
    echo "Failed to set access policy for user $currentUser on Key Vault $VaultName"
    exit 1
fi
echo "Access policy set for user $currentUser on Key Vault $VaultName"