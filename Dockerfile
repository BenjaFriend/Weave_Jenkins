FROM jenkins/jenkins
LABEL maintainer="benjamin.hoffman.dev@gmail.com"

# Create log folder
USER root
RUN mkdir /var/log/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
USER jenkins

# Set default options
ENV JAVA_OPTS="-Xmx4096m"
ENV JENKINS_OPTS=" --handlerCountMax=100"


