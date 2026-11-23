ARG NVM_TAG
# The build JDK this image's label promises (java11-nvm-sbt, java17-nvm-sbt). The agent itself
# runs on the core image's Java 21 through JENKINS_JAVA_BIN; builds use this JDK as JAVA_HOME.
ARG BUILD_JDK_IMAGE

FROM ${BUILD_JDK_IMAGE} AS build-jdk
FROM dwolla/sbt-version-cache AS sbt-cache
FROM dwolla/jenkins-agent-nvm:$NVM_TAG
LABEL maintainer="Dwolla Dev <dev+jenkins-nvm-sbt@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-nvm-sbt"

COPY --from=build-jdk /opt/java/openjdk /opt/java/build-jdk

ENV SBT_VERSION=1.6.2 \
    SBT_HOME=/usr/local/sbt \
    JAVA_HOME=/opt/java/build-jdk
ENV PATH=${SBT_HOME}/bin:${JAVA_HOME}/bin:${PATH}

COPY --from=sbt-cache /usr/local/sbt /usr/local/sbt
COPY --from=sbt-cache /root/.cache/coursier ${JENKINS_HOME}/.cache/coursier
COPY --from=sbt-cache /root/.ivy2 ${JENKINS_HOME}/.ivy2
COPY --from=sbt-cache /root/.sbt ${JENKINS_HOME}/.sbt

RUN export SDKMAN_DIR="${JENKINS_HOME}/.sdkman" && curl -s "https://get.sdkman.io" | bash

RUN chown -R jenkins:jenkins "${JENKINS_HOME}/.sdkman"

USER root
RUN chown -R jenkins ${JENKINS_HOME}

USER jenkins
