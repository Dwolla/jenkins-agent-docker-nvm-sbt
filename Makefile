NVM_TAG := $(NVM_JDK11_TAG)
JOB := core-${NVM_TAG}
CLEAN_JOB := clean-${NVM_TAG}

all: ${JOB}
clean: ${CLEAN_JOB}
.PHONY: all clean ${JOB} ${CLEAN_JOB}

${JOB}: core-%: Dockerfile
	docker buildx build \
	  --platform linux/arm64,linux/amd64 \
	  --build-arg NVM_TAG=$* \
	  --tag dwolla/jenkins-agent-nvm-sbt:$*-SNAPSHOT \
	  .

${CLEAN_JOB}: clean-%:
	docker image rm --force dwolla/jenkins-agent-nvm-sbt:$*-SNAPSHOT