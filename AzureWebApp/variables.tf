variable "rgname" {
  type = string
  description = "Resource Group Name"
}

variable "rglocation" {
  type = string
  description = "Resource Group Location"
  default = "eastus"
}

variable "aspname" {
  type = string
  description = "App Service Plan name"
}

variable "sku" {
  type = string
  description = "App Service Plan name"
}

variable "app-insight-name" {
  type = string
  description = "name of applicaiton insight"
}

variable "app-name" {
  type = string
  description = "Name of the web application"
}

variable "dotnet-command-line" {
  type = string
  description = "Startup dll of the dotnet application"
}

variable "dotnet-runtime" {
  type = string
  description = "Dotnet runtime stack (3.1, 5.0, 6.0, 7.0, 8.0)"
}

variable "app-settings" {
  type = map(string)
  description = "App settings for the web app"
}

variable "db-connection-string-name" {
  type = string
  description = "Name of database connection string"
}

variable "db-connection-string" {
  type = string
  description = "Database connection string"
}

variable "webapp-tags" {
  type = map(string)
  description = "tags for azure web app resource"
}