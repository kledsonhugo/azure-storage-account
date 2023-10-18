terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "tfstate"
  #   storage_account_name = "tfstatev001"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-github-actions-state"
    storage_account_name = "terraformgithubactions"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }

}

provider "azurerm" {
  features {}
  alias = "cloud"
}