#!/bin/bash

# DataOps Demo - File Upload Script
# This script uploads the Sales.csv file to the Azure Storage source container

# Configuration
RESOURCE_GROUP="rg-dataops-demo-eastus2"
STORAGE_ACCOUNT="stdataopsdemoeasus2025"
CONTAINER_NAME="source"
LOCAL_FILE="../demo_data/Sales.csv"
BLOB_PATH="Sales.csv"

echo "Starting file upload to Azure Data Lake..."

# Check if the file exists
if [ ! -f "$LOCAL_FILE" ]; then
    echo "Error: $LOCAL_FILE not found!"
    exit 1
fi

echo "Uploading Sales.csv to Azure Data Lake..."
az storage blob upload \
    --account-name "$STORAGE_ACCOUNT" \
    --container-name "$CONTAINER_NAME" \
    --name "$BLOB_PATH" \
    --file "$LOCAL_FILE" \
    --auth-mode key

if [ $? -eq 0 ]; then
    echo "Successfully uploaded $LOCAL_FILE to $BLOB_PATH"
    echo "File location: https://$STORAGE_ACCOUNT.blob.core.windows.net/$CONTAINER_NAME/$BLOB_PATH"
    
    # List files in the container to verify
    echo "Files in source container:"
    az storage blob list \
        --account-name "$STORAGE_ACCOUNT" \
        --container-name "$CONTAINER_NAME" \
        --auth-mode key \
        --output table
else
    echo "Failed to upload file"
    exit 1
fi

echo "Upload completed successfully!"
