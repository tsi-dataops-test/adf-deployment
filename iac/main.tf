terraform {
  required_providers {
    azurerm = {
      source = "registry.terraform.io/hashicorp/azurerm"
      version = ">= 2.70"
    }
  }
  backend "azurerm" {
    resource_group_name  = "use-case-factory-resources"
    storage_account_name = "ucfstorage"
    container_name       = "terraform-backend-v2"
    key                  = "dataops-test.terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "dataops-dev-rg" {
  name     = "${var.project_name}-rg"
  location = var.location
  tags = var.resource_tags
}
resource "azurerm_storage_account" "data_lake_storage" {
  name                     = "${var.project_name}datalake"
  resource_group_name      = azurerm_resource_group.dataops-dev-rg.name
  location                 = azurerm_resource_group.dataops-dev-rg.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  tags = var.resource_tags
}
resource "azurerm_storage_container" "data_lake_storage_landing_zone" {
  name                  = "dataopstestlandingzone"
  storage_account_name  = azurerm_storage_account.data_lake_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "data_lake_storage_archive" {
  name                  = "dataopstestarchive"
  storage_account_name  = azurerm_storage_account.data_lake_storage.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "data_lake_storage_delta" {
  name                  = "dataopstestdelta"
  storage_account_name  = azurerm_storage_account.data_lake_storage.name
  container_access_type = "private"
}
resource "azurerm_data_factory" "adf_test" {
  name                = "dataopsadf"
  resource_group_name = azurerm_resource_group.dataops-dev-rg.name
  location            = azurerm_resource_group.dataops-dev-rg.location

  github_configuration {
    account_name    = "tsi-dataops-test"
    branch_name     = "development"
    git_url         = "https://github.com"
    repository_name = "adf_deployment"
    root_folder     = "/adf_artifacts"
  }
}
