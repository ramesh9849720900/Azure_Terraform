provider "azurerm" {
  version = "~>2.0"
  features {}
}
##This is Resource group block
resource "azurerm_resource_group" "rg" {
  name = "terraform_resource_group"
  location = "East US"
}

##This is App Service block
resource "azurerm_app_service_plan" "app-service" {
  name                = "example-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "App"
  reserved             = false # Set to true for Linux
  sku {
    tier = "Standard"
    size = "S1"
  }
}


## This is Webapp block
resource "azurerm_app_service" "webapp9849" {
  name                = "webapp9849"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app-service.id
  site_config {
    dotnet_framework_version = "v4.0"
  }
}


##Backend configuration for terraform state files 
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform_resource_group"
    storage_account_name = "terraform9849"
    container_name       = "terraformblob"
    key                  = "terraform.tfstate"
  }
}
