## NOTE: This is one of the many ways of setting up an alert using Microsoft Sentinel and Log Analytics Playbooks to trigger an alert everytime the Breakglass account signs in. Depending on the customers licensing if they have Defender for Cloud Apps, the alert can be set up in [there as well](https://blog.ciaops.com/2023/10/24/monitoring-a-break-glass-account-with-defender-for-cloud-apps/)  or you can set this up manually as well by following the instructions under [Creating an alert rule](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access) & [Creating an Action group](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access) Make sure you test it after set up is complete to ensure that the alerts are working and getting generated. If you want to continue setting up using a Terraform Script, read through and follow the instructions below: 

# Terraform Configuration for Azure Sentinel and Log Analytics Workspace

This Terraform configuration sets up an Azure Sentinel and Log Analytics Workspace. Please refer to the [create sentinel log analytics workspace file](https://github.com/CodeBlue-NZ/cb-breakglass-account/blob/master/create-sentinel-la-workspace.tf) This file contains the configuration for the entire set up of the resources using terraform. 

## Resources Created

1. **Azure Provider**: This sets up the Azure provider for Terraform.

2. **Resource Group**: This creates a resource group named "RP-LA-WKSP-RG" in the "Australia East" location. Change the Resource group name according to your customer. 

3. **Log Analytics Workspace**: This creates a Log Analytics workspace named "RP-LA-WKSP" in the resource group created above. The pricing tier is set to "PerGB2018" and the data retention period is set to 30 days. Change the Workspace name according to your customer. 

4. **Log Analytics Solution**: This creates a Log Analytics solution named "SecurityInsights" in the same resource group and location. The solution is associated with the Log Analytics workspace created above. 

5. **Sentinel Scheduled Alert Rule**: This creates a Sentinel scheduled alert rule named "Breakglass Account Signin Alert". The rule is associated with the Log Analytics workspace and has a query that checks for sign-in activity of a specific user.

6. **Monitor Action Group**: This creates a monitor action group named "RP-SEN-ACTION-GROUP". The action group is associated with the resource group and has an email receiver configured. Change the action group name according to your customer. 

7. **Sentinel Data Connector for Azure Active Directory**: This creates a Sentinel data connector for Azure Active Directory named "RP-SEN-AD-CONNECTOR". The connector is associated with the Log Analytics workspace and a specific tenant ID. Change the data connector name according to your customer. 


## Manual Steps in the Azure Portal

Please refer to the [diagnostics.md](https://github.com/CodeBlue-NZ/cb-breakglass-account/blob/master/ConfigureDiagnostics.md) file and the [playbook.md](https://github.com/CodeBlue-NZ/cb-breakglass-account/blob/master/playbook.md) file which enables diagnostics on Entra ID for monitoring Audit and Signlogs & creates the playbook which runs everytime an incident is generated, they need to be created manually as terraform doesnt support them yet. Please create this after you run the terraform script, so that you can reference some of the names as answers to the resources you create. 

## Usage

To use this configuration, you need to have Terraform installed. You can then initialize Terraform in the directory containing this configuration using `terraform init`. After initialization, you can create the resources using `terraform apply`.

Please replace the placeholders(Resource group name, log analytics workspace name etc) in the configuration(create-sentinel-la-workspace.tf) with your actual values before running the commands.

## Requirements

- Terraform v0.12 or later
- An Azure account with the necessary permissions to create the resources. If the customer does not have an Azure subscription, then we cant set up any resources. 

## Note

This is a basic configuration and does not include all possible options. Depending on your use case, you may need to add more resources or modify the existing ones. There are some manual steps needed as well, please refer to the ConfigureDiagnoztics.md file for the steps and further info. 

It may take a couple of hours for the telemetry to update and the logs to appear. 
