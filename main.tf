terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "mysite-tfstate-rg"
    storage_account_name = "mysitetfstate482"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "site" {
  name     = "mysite-dev-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "site" {
  name                     = "mysitedevst482"
  resource_group_name      = azurerm_resource_group.site.name
  location                 = azurerm_resource_group.site.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_static_website" "site" {
  storage_account_id = azurerm_storage_account.site.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

output "website_url" {
  value = azurerm_storage_account.site.primary_web_endpoint
}