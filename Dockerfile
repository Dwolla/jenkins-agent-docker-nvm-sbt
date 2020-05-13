FROM dwolla/sbt-version-cache AS sbt-cache
FROM dwolla/sbt-plugins-cache AS sbt-plugins-cache
FROM openjdk:8-jdk AS jdk
FROM dwolla/jenkins-agent-nvm
LABEL maintainer="Dwolla Dev <dev+jenkins-nvm-sbt@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-nvm-sbt"

ENV SBT_VERSION=1.2.8 \
    SBT_HOME=/usr/local/sbt \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=${SBT_HOME}/bin:${JAVA_HOME}/bin:${PATH}

COPY --from=sbt-cache /usr/local/sbt /usr/local/sbt
COPY --from=sbt-cache /root/.ivy2 ${JENKINS_HOME}/.ivy2
COPY --from=sbt-cache /root/.sbt ${JENKINS_HOME}/.sbt
COPY --from=sbt-plugins-cache /root/.ivy2 ${JENKINS_HOME}/.ivy2
COPY --from=sbt-plugins-cache /root/.sbt ${JENKINS_HOME}/.sbt
COPY --from=jdk /usr/local/openjdk-8/ /usr/lib/jvm/java-8-openjdk-amd64

USER root
RUN chown -R jenkins ${JENKINS_HOME}

USER jenkins
