# jira-xray (Jira with Xray)
# A complete end-to-end automated testing environment for Jira

> See the presentation for this solution at (https://readysetagile.github.io/presentations/JiraXray.html#/)

This repo is a demo and case study for Automated Testing using Xray Test Management for Jira

------------------------------

In short, the solution works like this:
1. Teams can enter requirements or business needs (user story issue type) in Jira
2. Jira users can use the [Xray](https://www.getxray.app/) plugin to enter testing issues associated with the user story.  
	- The testing issue can be part of a Xray test plan and/or test set (suite)
	- Xray allows a test issue type to be a manual (step-by-step), generic (free form), or Cucumber (automated) test.
3. The automated tests can be automatically exported into cucumber feature files
4. The tests can be run in a test environment using your favorite CI/CD tool (e.g. Jenkins)
5. Xray plugins in Jenkins can import the results back into Jira, which create test execution issues which report the results of each test.  The issues are associated with the respective test and user story.
6. Xray also provides out-of-box reporting for each test set, test, and execution to trace test results back to each requirement or business need. 

------------------------------

##  Overall implementation

>
> * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE 
>

This repo is designed for you to try this solution in an isolated environment (i.e. docker containers).  That said, it is a _TESTING_ environment, meaning that
_this environment is not ready for a production_.  So, please be aware that certain security measures need to be taken before this solution is promoted to a non-development
environment, especially when considering communication between each container. 

### Licensing
- You will need a Jira license and Xray license to run this solution.  Evaluation licenses can be used.

### Docker
- You will need a [Docker](https://www.docker.com/) host to run this solution.  This solution was tested on Docker for Windows using the [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) on Windows 10.

### CI/CD environement

The overall container environment looks like this.  The main docker environment runs Jira and Jenkins containers in a simulated network.  When the time comes to test, 
Jenkins will dynamically spin up a slave Docker container that represents your application running in another isolated environment.  This slave container will then run commands
to execute your automated tests and import the results in separate issues in Jira to show the execution results. 
![Overall container environment](https://readysetagile.github.io/presentations/lib/img/atlassian/docker-env.svg)

### Case Study: GasTrak

The case study is a [simple web page](https://readysetagile.github.io/presentations/JiraXray.html#/6) used to enter gas pump filling data directly from the pump.
A user can enter data, provide automatic formatting, and save the results in a comma separated file.  

### Test plan

Here is the test plan we will be using.  Basically, we will be testing the user number formatting and other miscellaneous functionality.
![test plan](https://readysetagile.github.io/presentations/lib/img/atlassian/gastrak-test-plan.svg)

==============================
### Getting started
To get started with this solution and see it in action
1. Clone this repo
2. From the command prompt, run `docker-compose up -d`.  Wait for the images to download and the containers to start.
	- NOTE: the `docker-compose.yml` file contains reference to volume mounts for jenkins_home and jira_home relative to the `docker-compose.yml` file.  Change these to your convenience (so you wont have to run setup each time).
3. Build the slave image.  To do this, cd to the `jira-xray/jiraVolume/src` directory and run `docker build` to build the `ruby-cucumber-example` image.
4. [Configure Jira](https://github.com/readysetagile/jira-xray/tree/main/jiraVolume)
5. [Configure Jenkins](https://github.com/readysetagile/jira-xray/tree/main/jenkins_home)
6. Allow communication in your firewall (instructions in the Firewall section)
==============================

### Firewall
>
> * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE 
>
These instructions will get you started to help Jenkins communicate with your Docker host to spin up containers.  However **this is also a huge security risk**.  
Treat these instructions only to test your environment.

The Docker Jenkins plugin uses port 4243 to connect to the docker host.  However, the Windows Docker host only allows port 2375 to be exposed out-of-box (it can be configured otherwise) to not use any 
security protocols like TLS.  Therefore, to get this going simply, you can forward all tcp traffic from port 4243 to 2375 and allow the communication for the REST API.

Here's what I did to get this working in a Windows Docker host:
1. In a CLI, enter `netsh interface portproxy add v4tov4 listenport=4243 listenaddress=127.0.0.1 connectport=2375 connectaddress=127.0.0.1`
2. Open the docker settings (from the system tray) and check `"Expose daemon on tcp://localhost:2375 without TLS"' 

