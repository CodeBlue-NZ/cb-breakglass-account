## Unfortunately Terraform Doesnt support creating Logic Apps(Playbooks) yet, so we would need to create this manually. 

We need to create a playbook which generates an email and sends it to the action group email address.

For that we need to do the following steps manually within the Azure Portal. 

1. Create a playbook with incident trigger. -- Navigate to the Azure portal, in the search bar above type in Logic Apps and once the logic apps page pops up, click on + Add, This launches the Wizard to create the logic apps. Make sure the subscription is correct, select the resource group where all the other sentinel resources are/were created. Give the logic app a friendly name, select the region Australia-East. Select Yes for Enable Log Analytics and selecte the existing Log Analytics Workspace. Choose the consumption plan type. Review & Create.
   ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/1d97445e-af7d-4802-8aa4-3d73cc6be910)

2. Launch Log App Designer -- Once the Logic app is created, launch Logic App designer and add the first trigger, type in Sentinel and select the Microsoft Sentinel Incident (Preview) trigger, ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/3c9e5a27-5139-4991-8fb6-5b9679a5d15b)
 
3. Enable System assigned Identity and assign Azure Sentinel Contributor Role to the resource. -- We will use a system-assigned managed identity to run the Sentinel Trigger instead of using our own credentials, Under the logic app designer, click on connections, add new connection, connect with managed identity and create the new system assigned managed identity. Give it a friendly name and hit create: ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/0e8eacdc-e9cb-4e84-b4bb-72f26b272e9a) 

 This will automagically assign a system assigned managed identity. Next to to give the system assigned identity the relevant permissions. Under permissions click on Azure role assignements and click on Add role assignment (Preview), select the subscription and then set the scope to the resource group, subscription and select the Azure sentinel contributor role permission, ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/7d2bae4e-5bd6-47b1-b04d-be630f682a61) , Back to the logic app designer, Microsoft Sentinel Incident (Preview), under connected to, click change connection and select the newly created system assigned managed identity. ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/844bc6a5-9f52-4f5a-a5ee-6b7032b9e963) Save changes. 

4. Add Initialize Variable -- Click on add new step under the logic app designer, go to actions and select the variables action, select the initialize variable action. Give it a friendly name "Email Body" and set tye type to string. Leave the intial value empty. Save changes. ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/d2839a20-abae-4355-9c3f-4d2f56b5da93)

5. Set Logic For Each -- Click on Add new step and select/type in control built-in for each action, ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/d1e93c84-825e-4802-8f05-9d42d1126ca8) Under select an output from previous steps, click on add dynamic content, on the right hand corner search for alerts ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/36160f67-e628-4b82-822a-73e31adbbb95) and select Alerts(List of alerts related to this incident), Next Add an action, select variables, and select the set variables option, under name, hit the drop down and select the name of the variable that you saved earlier. ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/4931c1d0-8698-4c4a-b8f5-0bf0d0070922) , Under variable value, copy and paste this html script below: Note: You can change the wording to suit customer requirements.

```html
   <p>Hello Team,</p>
<p>You have an incident from Microsoft Sentinel. Below is information:</p>

<ul>
<li><strong>Alert Name:&nbsp;</strong>@{items('For_each')?['properties']?['alertDisplayName']}</li>
<li><strong>Description</strong>: @{triggerBody()?['object']?['properties']?['description']}</li>
<li><strong>Severity</strong>: @{triggerBody()?['object']?['properties']?['severity']}</li>
<li><strong>Incident ID</strong>: @{triggerBody()?['object']?['properties']?['incidentNumber']}</li>
<li><strong>Start Time</strong>: @{items('For_each')?['properties']?['startTimeUtc']}</li>
<li><strong>Incident URL</strong>: @{triggerBody()?['object']?['properties']?['incidentUrl']}</li>
</ul>

<p>Please review and update incident accordingly.</p>
<p>Sentinel Team</p>
```
Save changes. 

6. Send an email -- Add an action, type in email and select Office365 Outlook, under actions choose Send email (V2) ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/3b456652-0bc1-48e3-b500-560859f52356)  Select the To, set it to the action group email that was created earlier in terraform.  Select the Subject as Review Sentinel Alert(or whatever you and the customer choose as the alert subject) add dynamic content and select Incident title (This Dynamically adds the incident title to the subject line ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/141bd706-d785-4499-9f10-5e23fb879a47) Under Body, select the Email body as the variable and add it ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/dd6a5176-b9d0-4fde-a392-09ad4c34b226)  Set the Importance to High.  Save changes.
7. Now we need to go to the Sentinel Worksspace that was created by Terraform and go to Analytics, Clik on the Active rules, edit it ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/0e78c576-39ba-4db7-bd92-ee117c61d326), go to the automated response tab, under automation rules, click on add new and give the automation rule a name, with a trigger set to when an incident is created. Set the action to run playbook and from the drop down select the incident play book that we created above. Set the status to enabled, and hit apply. ![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/82af6c81-9a4b-4d9c-a267-f9375d76f349)  Save changes, review and create on the analytics rule. 
8. Test/Generate Sample Alerts. -- Try and login from an incognito browser on a different machine(away from the customers network) with the breakglass account. Login to the Azure portal/Office 365 portal, navigate to a few groups, search for a few user accounts. Wait for the alerts to come through. Note: Sometimes this might take about 90-120 mins.

### Example of a sample alert that I sent to myself. 

![image](https://github.com/CodeBlue-NZ/cb-breakglass-account/assets/48658717/c9ef500d-5600-4816-8a71-c1d30d155ead)

