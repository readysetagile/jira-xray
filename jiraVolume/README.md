# Setting up the Jira instance
This directory holds the docker volume for the Jira container (i.e. /var/atlassian/application-data/jira)

Once you have verified the container is running:

1. Navigate to `http://localhost:8080/`

2. Select `I'll set it up myself`
![jira-setup](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jiraVolume/setup-pics/jira-setup.png)

3. Make sure built-in is selected and click next
![db-setup](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jiraVolume/setup-pics/db-setup.png)

4. After the database is done setting up, on the `Set up application proprties screen`, click on the `import your data` link and click next.
![setup-apps.png](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jiraVolume/setup-pics/setup-apps.png)

5. On the import exising data screen
	- _File Name_: jira-xray-backup.zip (which will be in the imports directory)
	- _License_: use `https://my.atlassian.com/license/` to obtain a Jira software license (can be an evaluation license)
	- _Outgoing Mail_: can be enabled or disabled.
![import-existing-data](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jiraVolume/setup-pics/import-existing-data.png)

6. Once the data import is complete, you will be navigated to the Jira dashboard and asked for a login.  There is an admin user with this data.  Both the username and password are: **jiraxray**.  You should then see something similar to this screen.
![dashboard](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jiraVolume/setup-pics/dashboard.png)

7. Install the XRay plugin
	- nativate to the upper-right gear icon > Manage Apps > 
	- enter `Xray Test Management for Jira` in the `Search the marketplace` textbox
	- click the button that reads `Buy now`, `Install`, or `Evaluate` 
![xray-plugin](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jiraVolume/setup-pics/xray-plugin.png)
	- click Accept & Install
	- After install, click Get License to obtain an XRay license specific to your installation.  You can also obtain a eval license from Xpand It

8. Your Jira Software instance should now be ready to go!
