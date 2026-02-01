# Azure Image Builder Automation

This project automates the creation of custom Virtual Machine images in Azure using Azure Image Builder (AIB) and Terraform.

## Project Structure

*   `pipelines/`: Azure DevOps pipeline definitions.
*   `tf-image-factory/`: Terraform code to deploy Azure Image Builder templates.

## Pipeline Workflow

The `build-pipeline.yml` defines a two-stage process:

1.  **Infrastructure**:
    *   Initializes Terraform with an Azure backend.
    *   Applies the Terraform configuration to deploy or update AIB templates in the `rg-image-factory-001` resource group.

2.  **BuildImages**:
    *   Triggers the image build process for defined templates using the Azure CLI.
    *   Currently configured templates:
        *   Windows Server 2022
        *   Ubuntu 22.04
        *   RHEL 9
        *   AlmaLinux 9

## Configuration

Before running the pipeline, ensure the following variables in `pipelines/build-pipeline.yml` are updated:

*   `azureServiceConnection`: The name of your Azure DevOps Service Connection.
*   `backendAzureRmStorageAccountName`: The storage account for the Terraform state file.

## Usage

1.  Commit changes to the `tf-image-factory` directory or the pipeline file.
2.  The pipeline is triggered automatically on changes to `tf-image-factory/**`.
3.  Monitor the pipeline execution in Azure DevOps.

## Prerequisites

*   An Azure Subscription.
*   An Azure Storage Account for Terraform state (referenced as `tstate123` in the pipeline).
*   Appropriate permissions for the Service Connection to create resources and run AIB templates.
