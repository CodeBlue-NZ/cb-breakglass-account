 configure diagnostics for AAD from the Azure portal. Here are the steps:

Navigate to Entra ID in the Azure portal.
Select "Diagnostic settings" from the sidebar.
Click on "+ Add diagnostic setting".
Check the "AuditLogs" and "SignInLogs" checkboxes under "Log".
Under "Destination details", select "Send to Log Analytics workspace", and then select your workspace.
Click "Save".