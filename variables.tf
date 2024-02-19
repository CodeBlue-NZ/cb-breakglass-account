
## This is optional, use  only if you are using variables within the sentinal la workspaces.tf file 

variable "subscription_id" {
  description = "The ID of your Azure subscription"
  type        = string
}

variable "resource_group_name" {
  description = "The name of your Azure resource group"
  type        = string
}

variable "logic_app_name" {
  description = "The name of your Logic App"
  type        = string
}
