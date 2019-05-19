FROM jenkins/jenkins:latest

LABEL maintainer 4 All Digital  "joe@4alldigital.com"

# Asign root use to install libs required for mounted /var/run/docker.sock at runtime. 
USER root

# Install libs.
RUN apt-get update && apt-get install -y libltdl7

# Re-assign default runtime user.
USER jenkins
