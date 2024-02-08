# Define the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "RP-LA-WKSP-RG" {
  name     = "RP-LA-WKSP-RG"  # Name of the resource group
  location = "Australia East" # Location of the resource group
}

# Create a Log Analytics workspace
resource "azurerm_log_analytics_workspace" "RP-LA-WKSP" {
  name                = "RP-LA-WKSP"                                  # Name of the workspace
  location            = azurerm_resource_group.RP-LA-WKSP-RG.location # Location of the workspace
  resource_group_name = azurerm_resource_group.RP-LA-WKSP-RG.name     # Resource group of the workspace
  sku                 = "PerGB2018"                                   # Pricing tier of the workspace
  retention_in_days   = 30                                            # Data retention period in days
}

# Create a Log Analytics solution
resource "azurerm_log_analytics_solution" "RP-SEN-WKSP" {
  solution_name         = "SecurityInsights"                              # Name of the solution
  location              = azurerm_resource_group.RP-LA-WKSP-RG.location   # Location of the solution
  resource_group_name   = azurerm_resource_group.RP-LA-WKSP-RG.name       # Resource group of the solution
  workspace_resource_id = azurerm_log_analytics_workspace.RP-LA-WKSP.id   # Workspace associated with the solution
  workspace_name        = azurerm_log_analytics_workspace.RP-LA-WKSP.name # Name of the workspace

  plan {
    publisher = "Microsoft"                   # Publisher of the solution
    product   = "OMSGallery/SecurityInsights" # Product name of the solution
  }
}

# Create a Sentinel scheduled alert rule
resource "azurerm_sentinel_alert_rule_scheduled" "RP-SEN-ALERT" {
  name                       = "Breakglass Account Signin Alert"             # Name of the alert rule
  log_analytics_workspace_id = azurerm_log_analytics_workspace.RP-LA-WKSP.id # Workspace associated with the alert rule
  display_name               = "Breakglass Account Signin Alert"             # Display name of the alert rule
  severity                   = "High"                                        # Severity of the alert rule
  query                      = <<EOF
    SigninLogs
    | where UserPrincipalName == "breakfix@codebluedemo.onmicrosoft.com"
    | where OperationName == "Sign-in activity"
    | project TimeGenerated, UserPrincipalName, ClientAppUsed, LocationDetails, IPAddress, OperationName, ResultType, ResultSignature
  EOF
  query_frequency            = "PT1H"        # Frequency of the query
  query_period               = "PT1H"        # Period of the query
  trigger_operator           = "GreaterThan" # Operator of the trigger
  trigger_threshold          = 0             # Threshold of the trigger


}

# Create a monitor action group
resource "azurerm_monitor_action_group" "RP-SEN-ACTION-GROUP" {
  name                = "RP-SEN-ACTION-GROUP"                     # Name of the action group
  resource_group_name = azurerm_resource_group.RP-LA-WKSP-RG.name # Resource group of the action group
  short_name          = "RPSENAG"                                 # Short name of the action group

  email_receiver {
    name          = "RP"                       # Name of the email receiver
    email_address = "ravi.pudi@codeblue.co.nz" # Email address of the email receiver
  }
}

# Create a Sentinel data connector for Azure Active Directory
resource "azurerm_sentinel_data_connector_azure_active_directory" "RP-SEN-AD-CONNECTOR" {
  name                       = "RP-SEN-AD-CONNECTOR"                         # Name of the data connector
  log_analytics_workspace_id = azurerm_log_analytics_workspace.RP-LA-WKSP.id # Workspace associated with the data connector
  tenant_id                  = "47fbb2e2-4b7a-4a78-b2c0-d9469e31d8eb"        # Tenant ID associated with the data connector
}