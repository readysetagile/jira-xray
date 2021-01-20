FROM ruby:latest

RUN apt-get update \
  && apt-get install libxi6 \
  libnss3 \
  libgconf-2-4 \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libgtk-3-0 \
  libx11-xcb1 \
  libxss1 \
  lsb-release \
  xdg-utils \
  libgbm1 \
  cucumber \
  default-jre \
  libxcomposite1 -y


# install Chrome browser
RUN curl -L -o google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome.deb
RUN sed -i 's|HERE/chrome\"|HERE/chrome\" --disable-setuid-sandbox|g' /opt/google/chrome/google-chrome
RUN rm google-chrome.deb

# install chromedriver.  the major version of chrome must match the version of chromedriver (e.g. chrome 85 = chromedriver 85)
# get the latest version number from the chrome dev site
RUN CHROME_LATEST=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && wget "https://chromedriver.storage.googleapis.com/$CHROME_LATEST/chromedriver_linux64.zip"
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver
RUN rm chromedriver_linux64.zip

#install selenium-webdriver
RUN gem install selenium-webdriver

	
# Cleanup everything
RUN apt-get clean && apt-get -qy autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# Add user jenkins to the image
RUN adduser --quiet jenkins 

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd 
RUN mkdir /home/jenkins/.m2
	

RUN chown -R jenkins:jenkins /home/jenkins/.m2/
#RUN chown -R jenkins:jenkins /home/jenkins/.ssh/

#ADD . . to copy the source to the testing dir
#changed this to a local volume pointing to /usr/src/app

# create a mountpoint
VOLUME /usr/src/app

######################## possible uncomment these statements depending on slave commands

#CMD ["bundle", "init"]
#CMD ["bundle", "install"]
	
#CMD ["cucumber", "--require", "features", "--format", "pretty", "--format", "html", "--out", "output/report.html"]
