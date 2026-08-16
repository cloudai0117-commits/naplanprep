terraform {
  required_version = "~> 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.48.0"
    }
  }

  # Remote state — configure before first apply.
  # Create the storage account and container manually or via bootstrap script.
  backend "azurerm" {
    resource_group_name  = "npp-prod-rg-tfstate"
    storage_account_name = "npprodtfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy               = false
      recover_soft_deleted_key_vaults            = true
      purge_soft_deleted_secrets_on_destroy      = false
      recover_soft_deleted_secrets               = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

provider "azuread" {}

# Data source — current caller identity (used for Key Vault initial access policy)
data "azurerm_client_config" "current" {}
