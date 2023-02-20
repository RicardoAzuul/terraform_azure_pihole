terraform {
  # TODO: Add current version
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # TODO: Add current version
      version = "3.44.1"
    }
    random = {
      source = "hashicorp/random"
      # TODO: Add current version
      version = "3.4.3"
    }
  }
}

provider "azurerm" {
  features {}
}