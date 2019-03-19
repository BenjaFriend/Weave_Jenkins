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

# Install Cmake
RUN wget -qO- "https://cmake.org/files/v3.13/cmake-3.13.4-Linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr/local

#Install Boost
# Download boost, untar, setup install with bootstrap and only do the Program Options library,
# and then install
RUN cd /home && wget http://downloads.sourceforge.net/project/boost/boost/1.69.0/boost_1_69_0.tar.gz \
  && tar xfz boost_1_69_0.tar.gz \
  && rm boost_1_69_0.tar.gz \
  && cd boost_1_69_0 \
  && ./bootstrap.sh --prefix=/usr/local  \
  && ./b2 install \
  && cd /home \
  && rm -rf boost_1_69_0


RUN chown -R jenkins:jenkins /var/log/jenkins
USER jenkins
# Setting up environment variables for Jenkins admin user
ENV JENKINS_USER admin
ENV JENKINS_PASS admin

# Skip the initial setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Set default options
ENV JAVA_OPTS="-Xmx4096m"
ENV JENKINS_OPTS=" --handlerCountMax=100"
