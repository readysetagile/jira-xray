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
## TL;DR

[Get your containers up and running](#getting-started)

------------------------------
## System Requirements
You are going to be installing Jira and Jenkins servers on your machine running in parallel, which can require some hefty CPU cycles.  That said, you will also be running these in Docker containers.  Docker containers use of resources can be restricted to your system.  Also, I have not done any specific resource management to overcome the limitations (e.g. Orchestration tools like Kubernetes or Docker Swarm).  Perhaps that is in another future release (when I get some feedback from others :) ).

I am running this solution on my laptop which is taylored to business apps.  I do see a performance degrade during startup, however, I do not see any significant performance issues after.  
Here are the specs of my ASUS system
- CPU: AMD Ryzen 5 4500U with Radeon Graphics, 2375 Mhz, 6 Core(s), 6 Logical Processor(s)
- Installed Physical Memory (RAM): 8.00 GB
- Storage: Total=6.00 GB (Containers=5.00 GB, Container Volumes=1.00 GB)
	
------------------------------
##  Overall implementation

>
> **IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE**
>

This repo is designed for you to try this solution in an isolated environment (i.e. docker containers).  That said, it is a _TESTING_ environment, meaning that
_this environment is not ready for production_.  So, please be aware that certain security measures need to be taken before this solution is promoted to a non-development
environment, especially when considering communication between each container. 

### Licensing
- You will need a Jira license and Xray license to run this solution.  Evaluation licenses can be used.

### Docker
- You will need a [Docker](https://www.docker.com/) host to run this solution.  This solution was tested on Docker for Windows using the [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) on Windows 10.

### CI/CD environment

The overall container environment looks like this.  The main docker environment runs Jira and Jenkins containers in a simulated network.  When the time comes to test, 
Jenkins will dynamically spin up a slave Docker container that represents your application running in another isolated environment.  This slave container will then run commands
to execute your automated tests and import the results in separate issues in Jira to show the execution results. 
![Overall container environment](https://readysetagile.github.io/presentations/lib/img/atlassian/docker-env.svg)

### Case Study: GasTrak

The case study is a [simple web page](https://readysetagile.github.io/presentations/JiraXray.html#/6) used to enter gas pump filling data directly from the pump.
A user can enter data, which is automatically formatted, and the results are saved in a comma separated file.  

### Test plan

Here is the test plan we will be using.  Basically, we will be testing the user number formatting and other miscellaneous functionality.
![test plan](https://readysetagile.github.io/presentations/lib/img/atlassian/gastrak-test-plan.svg)

------------------------------
### Getting started
To get started with this solution and see it in action
[![installation vid](https://raw.githubusercontent.com/readysetagile/jira-xray/main/jiraVolume/setup-pics/installation-vid-cap.png)](https://drive.google.com/file/d/1F3432_sAUkNBWB3b434Equv8ebHkw7kX/view?usp=sharing "Watch the installation video")
- OR
#### Follow these steps
1. Clone this repo
2. From the command prompt, run `docker-compose up -d`.  Wait for the images to download and the containers to start.
	- NOTE: the `docker-compose.yml` file contains reference to volume mounts for jenkins_home and jira_home relative to the `docker-compose.yml` file.  Change these to your convenience (so you wont have to run setup each time).
3. Jira changes the permissions and ownership of the volume to store files.  Before you can use it, you need to change the permissions back to be read/write for everyone.  Here are the statements I used.
	```
	sudo find jiraVolume -type d -exec grep ugo+rwx {} \;
	sudo find jiraVolume -type f -exec grep ugo+rw {} \;
	```
4. Build the slave image.  To do this, cd to the `jira-xray/jiraVolume/src` directory and run `docker build . -t ruby-docker-slave` to build the `ruby-cucumber-example` image.
5. [Configure Jira](https://github.com/readysetagile/jira-xray/tree/main/jiraVolume)
6. [Configure Jenkins](https://github.com/readysetagile/jira-xray/tree/main/jenkins_home)
7. Allow communication in your firewall (instructions in the Firewall section)
------------------------------

### Firewall
>
> **IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE * IMPORTANT NOTE**
>
These instructions will get you started to help Jenkins communicate with your Docker host to spin up containers.  However **this is also a huge security risk**.  
Treat these instructions only to test your environment.

The Docker Jenkins plugin uses port 4243 to connect to the docker host.  However, the Windows Docker host only allows port 2375 to be exposed out-of-box (it can be configured otherwise) to not use any 
security protocols like TLS.  Therefore, to get this going simply, you can forward all tcp traffic from port 4243 to 2375 and allow the communication for the REST API.

Here's what I did to get this working in a Windows Docker host:
1. In a CLI, enter `netsh interface portproxy add v4tov4 listenport=4243 listenaddress=127.0.0.1 connectport=2375 connectaddress=127.0.0.1`
2. Open the docker settings (from the system tray) and check `"Expose daemon on tcp://localhost:2375 without TLS"`

------------------------------

## Removal

After you have tested this solution, you can easily remove it from your system with the following steps:

1. Stop the containers from the command line
	```
	cd jira-xray
	docker-compose down	
	```
2. Remove the images from the docker host, and prune your system
	``` 
	docker image rm jira-xray_jenkins ruby-docker-slave jenkins/jenkins ruby atlassian/jira-software
	docker system prune
	```
3. Delete the jira-xray directory and sub-directories
	```
	sudo rm -R jira-xray
	```
	