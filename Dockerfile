FROM jenkins/jenkins:latest

LABEL maintainer 4 All Digital  "joe@4alldigital.com"

# Asign root use to install libs required for mounted /var/run/docker.sock at runtime. 
USER root

# Install libs.
RUN apt-get update && \
    apt-get -y install apt-transport-https \
    rsync \
    ca-certificates \
    curl \
    gnupg2 \
    libltdl7 \
    ssh-client \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
    apt-get update && \
    apt-get -y install libltdl7 docker-ce && \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# Re-assign default runtime user.
USER jenkins

# Re-assign default runtime user.
USER jenkins
