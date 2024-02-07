terraform {
  required_version = ">= 1.0.0"

  backend "azurerm" {
    resource_group_name   = "ref-arch"
    storage_account_name  = "htcdemo00azuretfstate"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
