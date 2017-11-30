FROM openjdk:8-jre
MAINTAINER Dwolla Dev <dev+jenkins-nvm@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-nvm"

ENV JENKINS_HOME=/home/jenkins \
    JENKINS_AGENT=/usr/share/jenkins \
    AGENT_VERSION=2.61 \
    NVM_VERSION=v0.33.6 \
    SBT_VERSION=1.0.4 \
    SBT_HOME=/usr/local/sbt

ENV PATH=${SBT_HOME}/bin:${PATH} \
    NVM_DIR="${JENKINS_HOME}/.nvm"

WORKDIR ${JENKINS_HOME}

COPY jenkins-agent /usr/local/bin/jenkins-agent
COPY verify.sh /usr/local/bin/verify.sh
COPY fake-project $JENKINS_HOME/fake-project

# apt-key loop inspired by https://github.com/nodejs/docker-node/issues/340#issuecomment-321669029
RUN set -ex && \
    apt-get update && \
    apt-get install -y curl bash git ca-certificates python python-pip make rake g++ apt-transport-https ca-certificates bc jq && \
    for key in \
      58118E89F3A912897C070ADBF76221572C52609D \
    ; do \
      apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" || \
      apt-key adv --keyserver hkp://keyserver.pgp.com:80 --recv-keys "$key" || \
      apt-key adv --keyserver hkp://ipv4.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
    done && \
    echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-engine && \
    pip install awscli && \
    curl --create-dirs -sSLo ${JENKINS_AGENT}/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${AGENT_VERSION}/remoting-${AGENT_VERSION}.jar && \
    chmod 755 ${JENKINS_AGENT} && \
    chmod 644 ${JENKINS_AGENT}/agent.jar && \
    mkdir -p ${JENKINS_HOME} && \
    useradd --home ${JENKINS_HOME} --system jenkins && \
    chown -R jenkins ${JENKINS_HOME} && \
    chmod 755 /usr/local/bin/jenkins-agent && \
    apt-get clean && \
    curl -sL /tmp/sbt-${SBT_VERSION}.tgz "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | \
    gunzip | tar -x -C /usr/local

USER jenkins

RUN curl -sL https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | /bin/bash

RUN git config --global user.email "dev+jenkins@dwolla.com" && \
    git config --global user.name "Jenkins Build Agent"

RUN cd $JENKINS_HOME/fake-project && \
    echo sbt.version=0.13.16 > project/build.properties && \
    sbt -Dsbt.log.noformat=true clean +compile && \
    echo sbt.version=${SBT_VERSION} > project/build.properties && \
    sbt -Dsbt.log.noformat=true clean +compile && \
    rm -rf $JENKINS_HOME/fake-project

ENTRYPOINT ["jenkins-agent"]
