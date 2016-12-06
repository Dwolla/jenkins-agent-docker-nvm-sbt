FROM openjdk:8-jre
MAINTAINER Dwolla Dev <dev+jenkins-nvm@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-nvm"

ENV JENKINS_HOME=/home/jenkins \
    JENKINS_AGENT=/usr/share/jenkins \
    AGENT_VERSION=2.61
ENV NVM_VERSION=v0.32.0 \
    NVM_DIR="${JENKINS_HOME}/.nvm"

COPY jenkins-agent /usr/local/bin/jenkins-agent
COPY verify.sh /usr/local/bin/verify.sh

RUN apt-get update && \
    apt-get install -y curl bash git ca-certificates python make g++ && \
    curl --create-dirs -sSLo ${JENKINS_AGENT}/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${AGENT_VERSION}/remoting-${AGENT_VERSION}.jar && \
    chmod 755 ${JENKINS_AGENT} && \
    chmod 644 ${JENKINS_AGENT}/agent.jar && \
    mkdir -p ${JENKINS_HOME} && \
    useradd --home ${JENKINS_HOME} --system jenkins && \
    chown -R jenkins ${JENKINS_HOME} && \
    chmod 755 /usr/local/bin/jenkins-agent && \
    apt-get clean

WORKDIR ${JENKINS_HOME}
USER jenkins

RUN curl -L https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | /bin/bash

ENV SBT_VERSION=0.13.13 \
    SBT_HOME=/usr/local/sbt \
    SCALA_VERSION=2.11.8
ENV PATH=${SBT_HOME}/bin:${PATH}

USER root

RUN apt-get install git && \
    curl -sL /tmp/sbt-${SBT_VERSION}.tgz "https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | \
    gunzip | tar -x -C /usr/local && \
    [ "0.13.13" = "${SBT_VERSION}" ] && mv /usr/local/sbt-launcher-packaging-${SBT_VERSION} /usr/local/sbt

USER jenkins

RUN printf "set scalaVersion := \"${SCALA_VERSION}\"\nupdate-sbt-classifiers\nsbtVersion\n" | sbt && \
    rm -rf $JENKINS_HOME/project/ $JENKINS_HOME/target/

RUN git config --global user.email "dev+jenkins@dwolla.com" && \
    git config --global user.name "Jenkins Build Agent"

ENTRYPOINT ["jenkins-agent"]
