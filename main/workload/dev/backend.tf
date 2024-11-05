terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.104.0"
    }
  }
  backend "azurerm" {
    container_name       = "rs-tfstate-blob" # container name of workload, cannot use $variable
    key                  = "dev.terraform.tfstate"
  }
}
