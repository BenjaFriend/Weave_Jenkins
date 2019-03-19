FROM jenkins/jenkins
LABEL maintainer="benjamin.hoffman.dev@gmail.com"

# Create log folder
USER root
RUN mkdir /var/log/jenkins
RUN apt-get update -y
RUN apt-get install tar -y
RUN apt-get install wget -y
RUN apt-get install build-essential -y
RUN apt-get install vim -y
RUN apt-get install gcc -y

RUN wget -qO- "https://cmake.org/files/v3.13/cmake-3.13.4-Linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr/local
RUN chown -R jenkins:jenkins /var/log/jenkins
USER jenkins

# Installing the plugins we need using the in-built install-plugins.sh script
#RUN /usr/local/bin/install-plugins.sh git matrix-auth workflow-aggregator docker-workflow blueocean credentials-binding

# Setting up environment variables for Jenkins admin user
ENV JENKINS_USER admin
ENV JENKINS_PASS admin

# Skip the initial setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Set default options
ENV JAVA_OPTS="-Xmx4096m"
ENV JENKINS_OPTS=" --handlerCountMax=100"
