# Setting up the Jira instance
This directory holds the docker volume for the Jira container (i.e. /var/atlassian/application-data/jira)

This installation comes pre-installed with Jira and a sample internal H2 database.  The only things that you have to do are install the Xray addon and apply your licenses. 

Once you have verified the container is running:

1. Navigate to `http://localhost:8080/`.  Login with the administrator account.  Both the username and password are: **jiraxray**.

2. At this point, you might be asked to update the expired Jira license.  You can follow the prompts to add an evaluation license, or grab one at [My Atlassian](https://my.atlassian.com/).  You will need a **Jira Software (Server): Trial**.

3. Install the XRay plugin
	- From the dashboard, nativate to the **upper-right gear icon > Manage Apps >**
	- enter `Xray Test Management for Jira` in the `Search the marketplace` textbox
	- click the button that reads `Buy now`, `Install`, or `Evaluate` 
![xray-plugin](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jiraVolume/setup-pics/xray-plugin.png)
	- click Accept & Install
	- After install, click Get License to obtain an XRay license specific to your installation.  You can also obtain a eval license from Xpand It.  The license you are looking for is **Xray Test Management for Jira: Trial**

4. Your Jira Software instance should now be ready to go!

[Go back to the main installation instructions](https://github.com/readysetagile/jira-xray#getting-started)