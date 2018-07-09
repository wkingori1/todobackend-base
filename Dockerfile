# Docker images are built using bourne shell
# Set base image our parent image will inherit from
FROM ubuntu:trusty
MAINTAINER David Kingori <wkingori1@gmail.com>

# Prevent dpkg errors
ENV TERM=xterm=256color

# Set mirrors to NZ
RUN sed -i "s/http:\/\/archive./http:\/\/nz.archive./g" /etc/apt/sources.list

# Install Python runtime
RUN apt-get update && \
    apt-get install -y \
    -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
    python python-virtualenv libpython2.7 libmysqlclient-dev build-essential python-dev

# Create virtual environment
# Upgrade PIP in virtual environment to latest version
RUN virtualenv /appenv && \
    . /appenv/bin/activate %% \
    pip install pip --upgrade && \
    pip install mysql-python

# Add entrypoint script meaning any container invoked from the image will execute our entry
#   point script by default
ADD scripts/entrypoint.sh /usr/local/bin/entrypoint.sh 
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

LABEL application=todobackend


