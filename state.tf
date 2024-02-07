locals {
  backend_config = <<EOT
terraform {
  required_version = ">= 1.0.0"

  backend "azurerm" {
    resource_group_name   = "${module.base.resource_group_name}"
    storage_account_name  = "${azurerm_storage_account.tfstate.name}"
    container_name        = "${azurerm_storage_container.tfstate.name}"
    key                   = "terraform.tfstate"
  }
}
EOT
}

resource "azurerm_storage_account" "tfstate" {
  name                            = "${substr(replace(var.humanitec_org_id, "-", ""), 0, 16)}tfstate"
  resource_group_name             = module.base.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

resource "local_file" "terraform_backend_config" {
  content         = local.backend_config
  filename        = "backend.tf"
  file_permission = "0644"
}
