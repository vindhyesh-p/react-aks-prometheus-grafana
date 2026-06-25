terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>4.0"
        }
    }
}
provider "azurerm"{
    features {}
    subscription_id = "7454c207-6484-4225-8771-680428895c08"
}