## Unfortunately Terraform Doesnt support creating Logic Apps(Playbooks) yet, so we would need to create this manually. 

We need to create a playbook which generates an email and sends it to the action group email address.

For that we need to do the following steps manually within the Azure Portal. 

1. Create a playbook with incident trigger. -- Navigate to the Azure portal, in the search bar above type in Logic Apps and once the logic apps page pops up, click on + Add, This launches the Wizard to create the logic apps. Make sure the subscription is correct, select the resource group where all the other sentinel resources are/were created. Give the logic app a friendly name, select the region Australia-East. Select Yes for Enable Log Analytics and selecte the existing Log Analytics Workspace. Choose the consumption plan type. Review & Create.
   ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/1d97445e-af7d-4802-8aa4-3d73cc6be910)

2. Launch Log App Designer -- Once the Logic app is created, launch Logic App designer and add the first trigger, type in Sentinel and select the Microsoft Sentinel Incident (Preview) trigger, ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/3c9e5a27-5139-4991-8fb6-5b9679a5d15b)
 
3. Enable System assigned Identity and assign Azure Sentinel Contributor Role to the resource. -- We will use a system-assigned managed identity to run the Sentinel Trigger instead of using our own credentials, Under the logic app designer, click on identity, click on the system assigned tab and change the status to on. Hit save. ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/f07ece7f-57d5-4148-a966-b92fea98c52f)
 This will automagically assign a system assigned managed identity. Next to to give the system assigned identity the relevant permissions. Under permissions click on Azure role assignements and click on Add role assignment (Preview), select the subscription and then set the scope to the resource group, subscription and select the Azure sentinel contributor role permission, ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/7d2bae4e-5bd6-47b1-b04d-be630f682a61)

4. Modify Playbook created in Step 1 to use "Send an Email V2 action"
5. Attach Playbook to one of the alerts. 
6. Test/Generate Sample Alerts. 

