FROM jenkins/jenkins:lts

#install plugins 
RUN jenkins-plugin-cli --plugins docker-plugin xray-connector

# Skip initial setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"