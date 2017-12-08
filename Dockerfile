FROM dwolla/jenkins-agent-nvm
MAINTAINER Dwolla Dev <dev+jenkins-nvm-sbt@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-nvm-sbt"

ENV SBT_VERSION=1.0.4 \
    SBT_HOME=/usr/local/sbt

ENV PATH=${SBT_HOME}/bin:${PATH}

COPY fake-project $JENKINS_HOME/fake-project

USER root

RUN chown -R jenkins ${JENKINS_HOME} && \
    curl -sL /tmp/sbt-${SBT_VERSION}.tgz "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | \
    gunzip | tar -x -C /usr/local

USER jenkins

RUN cd $JENKINS_HOME/fake-project && \
    echo sbt.version=0.13.16 > project/build.properties && \
    sbt -Dsbt.log.noformat=true clean +compile && \
    echo sbt.version=${SBT_VERSION} > project/build.properties && \
    sbt -Dsbt.log.noformat=true clean +compile && \
    rm -rf $JENKINS_HOME/fake-project

ENTRYPOINT ["jenkins-agent"]
