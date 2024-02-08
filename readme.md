# Terraform Configuration for Azure Sentinel and Log Analytics Workspace

This Terraform configuration sets up an Azure Sentinel and Log Analytics Workspace.

## Resources Created

1. **Azure Provider**: This sets up the Azure provider for Terraform.

2. **Resource Group**: This creates a resource group named "RP-LA-WKSP-RG" in the "Australia East" location.

3. **Log Analytics Workspace**: This creates a Log Analytics workspace named "RP-LA-WKSP" in the resource group created above. The pricing tier is set to "PerGB2018" and the data retention period is set to 30 days.

4. **Log Analytics Solution**: This creates a Log Analytics solution named "SecurityInsights" in the same resource group and location. The solution is associated with the Log Analytics workspace created above.

5. **Sentinel Scheduled Alert Rule**: This creates a Sentinel scheduled alert rule named "Breakglass Account Signin Alert". The rule is associated with the Log Analytics workspace and has a query that checks for sign-in activity of a specific user.

6. **Monitor Action Group**: This creates a monitor action group named "RP-SEN-ACTION-GROUP". The action group is associated with the resource group and has an email receiver configured.

7. **Sentinel Data Connector for Azure Active Directory**: This creates a Sentinel data connector for Azure Active Directory named "RP-SEN-AD-CONNECTOR". The connector is associated with the Log Analytics workspace and a specific tenant ID.

## Usage

To use this configuration, you need to have Terraform installed. You can then initialize Terraform in the directory containing this configuration using `terraform init`. After initialization, you can create the resources using `terraform apply`.

Please replace the placeholders in the configuration with your actual values before running the commands.

## Requirements

- Terraform v0.12 or later
- An Azure account with the necessary permissions to create the resources

## Note

This is a basic configuration and does not include all possible options. Depending on your use case, you may need to add more resources or modify the existing ones. There are some manual steps needed as well, please refer to the ConfigureDiagnoztics.md file for the steps and further info. 

It may take a couple of hours for the telemetry to update and the logs to appear. 