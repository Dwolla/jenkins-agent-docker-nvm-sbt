# Jenkins Agent with nvm and sbt

[![](https://images.microbadger.com/badges/image/dwolla/jenkins-agent-nvm-sbt.svg)](https://microbadger.com/images/dwolla/jenkins-agent-nvm-sbt)
[![license](https://img.shields.io/github/license/dwolla/jenkins-agent-docker-nvm-sbt.svg?style=flat-square)](https://github.com/Dwolla/jenkins-agent-docker-nvm-sbt/blob/master/LICENSE)

Docker image that makes [nvm](https://github.com/creationix/nvm) and [sbt](http://scala-sbt.org/) available to Jenkins jobs, based on Dwolla’s [sbt-version-cache](https://github.com/Dwolla/docker-sbt-version-cache) image.

## Local Development

With [yq](https://kislyuk.github.io/yq/) installed, to build this image locally run the following command:

```bash
make \
    NVM_TAG=$( curl --silent https://raw.githubusercontent.com/Dwolla/jenkins-agents-workflow/main/.github/workflows/build-docker-image.yml | \
        yq .on.workflow_call.inputs.NVM_TAG.default) \
    all
```

Alternatively, without [yq](https://kislyuk.github.io/yq/) installed, refer to the NVM_TAG default values defined in [jenkins-agents-workflow](https://github.com/Dwolla/jenkins-agents-workflow/blob/main/.github/workflows/build-docker-image.yml) and run the following command:

`make NVM_TAG=<default-nvm-tag-from-jenkins-agents-workflow> all`