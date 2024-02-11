 # Configure diagnostics for AAD from the Azure portal. Here are the steps:

Navigate to Entra ID in the Azure portal. ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/a3c8a858-c3c8-4ec7-b49e-f6595d244e21)

Select "Diagnostic settings" from the sidebar. ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/dccc7383-8380-4307-99fe-e14032e6324a)

Click on "+ Add diagnostic setting". ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/ac28aa82-e90b-4031-bf6c-47cde7206466)

Check the "AuditLogs" and "SignInLogs" checkboxes under "Log". ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/9402dea4-3560-4e60-9535-3d33f8ccf6de)

Under "Destination details", select "Send to Log Analytics workspace", and then select your workspace. ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/85f0587b-345a-421e-8ab2-73eab9e2c01b)

Click "Save". 
