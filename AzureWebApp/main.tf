terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.104.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id   = "d204dc38-72e2-4c5d-a3c0-1b61a73e146a"
  client_id         = "2b492345-fb5c-4060-bfe8-6960063c9976"
  client_secret     = "" # Need to set once cloned git repo
  tenant_id         = "5372b173-6565-4f3c-b9e6-1d6df2cd3697"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "padmasekhar-learn"             # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "pslearnstorage"                                 # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"                   # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    access_key           = ""  # Need to set once cloned git repo
  }
}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                  = "${var.aspname}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  os_type               = "Linux"
  sku_name              = "${var.sku}"
}

# Application Insights
resource "azurerm_application_insights" "appinsights" {
  name                = "${var.app-insight-name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

# App Service
resource "azurerm_linux_web_app" "webapp" {
  name                = "${var.app-name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = false
    app_command_line = "${var.dotnet-command-line}"
    application_stack {
      dotnet_version = "${var.dotnet-runtime}"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = merge({
    "APPINSIGHTS_INSTRUMENTATIONKEY"  = azurerm_application_insights.appinsights.instrumentation_key
    "WEBSITE_RUN_FROM_PACKAGE"        = "1"
  },
  var.app-settings
  )

  connection_string {
    name  = "${var.db-connection-string-name}"
    type  = "SQLAzure"
    value = "${var.db-connection-string}"
  }

  tags = var.webapp-tags
}

output "webapp_name" {
  value = azurerm_linux_web_app.webapp.name
}
