terraform {
  required_version = "~>1.8"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.104.0"
    }
  }

  backend "azurerm" {
    container_name = "" # container name of backend part, cannot use $variable
    key            = "dev.terraform.tfstate"
  }
}