FROM gitlab/gitlab-ce:latest
MAINTAINER François Scala

# Subgit version
ENV SUBGIT_VERSION 3.3.10

# Install Java
RUN apt-get update && \
    apt-get install -y openjdk-8-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Download subgit from official website and install
RUN curl -o subgit.deb -q https://subgit.com/files/subgit_${SUBGIT_VERSION}_all.deb && \
    dpkg -i subgit.deb && \
    rm -fr subgit.deb

# Fix SNI error with Java 7
RUN sed -i '/^EXTRA_JVM_ARGUMENTS.*/a EXTRA_JVM_ARGUMENTS="$EXTRA_JVM_ARGUMENTS -Djsse.enableSNIExtension=false"' /usr/bin/subgit

# Define data volumes
VOLUME ["/etc/gitlab", "/etc/subgit", "/var/opt/gitlab", "/var/log/gitlab"]
