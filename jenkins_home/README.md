# Setting up the Jira instance
This directory holds the docker volume for Jenkins (i.e. /var/jenkins_home)

Once you have verified the container is running:

1. Navigate to `http://localhost:9090/`

2. This instance does not have security enabled, so you will see the jobs screen with the `jira-xray` job.  You cannot run jobs yet because the correct plugins will not be installed.
![jenkins-jobs](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/jenkins-jobs.png)

3. Navigate to `Manage Jenkins` on then left, then the `Manage Plugins` button
![manage-plugins](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/manage-plugins.png)

4. Click on the `Available` tab and search for `docker`.  Check the Docker plugin, and then `Install without restart`
![docker-plugin](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/docker-plugin.png)

5. You will see the progress of the installation.  When it's done, click the link that reads `Go back to the top page`

6. Repeat the previous three steps for the `Xray - Test Management for Jira` plugin
![xray-plugin](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/xray-plugin.png)

7. Now you need to configure the plugins.  From the top menu, navigate to Manage Jenkins > Configure System > scroll down to Xray Configuration
![xray-config](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/xray-config.png)

8. Fill in the configuration alias and use `http://host.docker.internal:8080/` for the Jira URL.

9. Now add some credentials.  These are the credentials that Jenkins will use to log into your Jira instance and use its REST API to extract XRay tests into feature files.  You can use the default credentials of **jiraxray** as the username and password
![add-creds](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/add-creds.png)

10. Make sure you test the connection and get the `Connection: Success!` message

11. Save the config.  Now scroll to the bottom of the page to configure a cloud using the `separate configuration page`

12. Add a new cloud
![add-cloud](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/add-cloud.png)

13. Name the cloud and click `Docker Cloud Details...`
![name-cloud](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/name-cloud.png)

14. In the Configure Clouds module, set the Docker Host URI as `tcp://host.docker.internal:4243` and check Enable.
	- **NOTE:  make sure you don't skip the impratant step to configure the firewall **
![config-cloud](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/config-cloud.png)

15. Click Docker Agent Templates.  Set the Label, Name and Docker Image to `ruby-docker-slave`.  This is the slave container that the addon will dynamically start to run the automated tests.
![docker-agent-templates](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/docker-agent-templates.png)

16. Save this config, and head mack to the main screen.

------------------------------------

## Configure the build job

------------------------------------

Your final work is to configure the build job to extract the tests, test them, and then import the results back to Jira

1. From the main build screen, click the arrow next to the `jira-xray` job and click Configure
![config-build](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/config-build.png)

2. Make sure `Restrict where this project can be run` is checked, and set it to the name of the cloud you set (i.e. `ruby-docker-slave`)
![restrict-build](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/restrict-build.png)

3. Configure your build steps
	- The first to remove old feature files (optional)
![build-remove-features](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/build-remove-features.png)
	- Add a task for `Xray: Cucumber Features Export Task`.  Set the issues to a list of tags from your Jira project (e.g. GTT-4).  
	- Set the path to `/var/atlassian/application-data/jira/src/ruby-cucumber-example/features`.  This is where the plugin will export the feature files it extracts from your Jira "Test" issues.
![xray-export](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/xray-export.png)
	- Add another Execute Shell step.  These are the commands to run inside the slave container to execute the test suite.  
![execute-tests](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/execute-tests.png)
		```
		echo "Execute the tests"
		cd /var/atlassian/application-data/jira/src/ruby-cucumber-example
		bundle install
		cucumber --expand --format json_pretty --out output/report.json
		```

4. Now add a post-build step to `Xray: Results Import Task`.  Set the `Execution Report File (file path with file name)` to `/var/atlassian/application-data/jira/src/ruby-cucumber-example/output/report.json`.  This is the file that Jira will parse into a new Test Execution issue
![post-build](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/post-build.png)

5. You are now ready to execute the build!  Head back to the main build screen.  Click the arrow next to the jira-xray job and click `Build`
![build-now](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/build-now.png)

6.  You should see the progress of the build, and then the execution results.  You can check out the console output for success or failure.
![console-out](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jenkins_home/setup-pics/build-now.png)
