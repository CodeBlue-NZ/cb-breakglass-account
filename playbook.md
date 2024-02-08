We need to create a playbook which generates an email and sends it to the action group email address. 

For that we need to do the following steps manually within the Azure Portal. 

1. Create a playbook with incident trigger.
2. Enable System assigned Identity and assign Azure Sentinel Contributor Role to the resource. 
3. Modify Playbook created in Step 1 to use "Send an Email V2 action"
4. Attach Playbook to one of the alerts. 
5. Test/Generate Sample Alerts. 

