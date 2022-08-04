# Jenkins Agent with nvm and sbt

[![](https://images.microbadger.com/badges/image/dwolla/jenkins-agent-nvm-sbt.svg)](https://microbadger.com/images/dwolla/jenkins-agent-nvm-sbt)
[![license](https://img.shields.io/github/license/dwolla/jenkins-agent-docker-nvm-sbt.svg?style=flat-square)](https://github.com/Dwolla/jenkins-agent-docker-nvm-sbt/blob/master/LICENSE)

Docker image that makes [nvm](https://github.com/creationix/nvm) and [sbt](http://scala-sbt.org/) available to Jenkins jobs, based on Dwolla’s [sbt-version-cache](https://github.com/Dwolla/docker-sbt-version-cache) image.

## Local Development

With [yq](https://kislyuk.github.io/yq/) installed, to build this image locally run the following command:

```bash
make \
    NVM_JDK8_TAG=$(curl --silent https://raw.githubusercontent.com/Dwolla/jenkins-agents-workflow/main/.github/workflows/build-docker-image.yml | \
        yq -r .jobs.\"build-nvm-matrix\".strategy.matrix.TAG | yq '.[] | select (test(".*?jdk8.*?"))') \
    NVM_JDK11_TAG=$( curl --silent https://raw.githubusercontent.com/Dwolla/jenkins-agents-workflow/main/.github/workflows/build-docker-image.yml | \
        yq -r .jobs.\"build-nvm-matrix\".strategy.matrix.TAG | yq '.[] | select (test(".*?jdk11.*?"))') \
    all
```

Alternatively, without [yq](https://kislyuk.github.io/yq/) installed, refer to the NVM_TAG default values defined in [jenkins-agents-workflow](https://github.com/Dwolla/jenkins-agents-workflow/blob/main/.github/workflows/build-docker-image.yml) and run the following command:

`make NVM_JDK11_TAG=<default-nvm-jdk11-tag-from-jenkins-agents-workflow> NVM_JDK8_TAG=<default-nvm-jdk8-tag-from-jenkins-agents-workflow> all`