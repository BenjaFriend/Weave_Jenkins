FROM jenkins/jenkins
LABEL maintainer="benjamin.hoffman.dev@gmail.com"

# Create log folder
USER root
RUN mkdir /var/log/jenkins
RUN apt-get update -y
RUN apt-get install tar -y
RUN apt-get install wget -y
RUN apt-get install build-essential -y
RUN apt-get install clang gcc g++ git -y


# Install Clang 8.0
#RUN apt-get install -y                                                                                  \
#   xz-utils                                                                                             \
#   build-essential                                                                                      \
#   curl                                                                                                 \
#   && rm -rf /var/lib/apt/lists/*                                                                       \
#   && curl -SL http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz     \
#   | tar -xJC . &&                                                                                      \
#   mv clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04 clang_8.0.0 &&                                     \
#   echo 'export PATH=/clang_8.0.0/bin:$PATH' >> ~/.bashrc &&                                            \
#   echo 'export LD_LIBRARY_PATH=/clang_8.0.0/lib:LD_LIBRARY_PATH' >> ~/.bashrc


# Install Cmake
RUN wget -qO- "https://cmake.org/files/v3.13/cmake-3.13.4-Linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr/local

#Install Boost
WORKDIR /home
RUN pwd && ls -la                                                                                       \
    && wget --quiet --max-redirect 3 https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz  \
    && tar zxf boost_1_69_0.tar.gz -C /usr/include/                                                     \ 
    && rm -rf /home/boost_1_69_0.tar.gz

WORKDIR /usr/include/boost_1_69_0/
RUN ./bootstrap.sh
RUN ./b2 --with-system --with-thread --with-date_time --with-regex --with-serialization stage
ENV BOOST_LIBRARYDIR="/usr/include/boost_1_69_0/stage/lib/"
ENV BOOST_ROOT="/usr/include/boost_1_69_0"

# Copy plugin settings
COPY plugins.txt /var/jenkins_home/plugins.txt
RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt

# Add jobs
COPY jobs/1-weave-server-job.xml /usr/share/jenkins/ref/jobs/1-weave-server-job/config.xml

# Make a log directory and a jenkins user
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
