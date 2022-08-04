NVM_TAGS := $(NVM_JDK8_TAG) $(NVM_JDK11_TAG)
JOBS := $(addprefix core-,${NVM_TAGS})
CLEAN_JOBS := $(addprefix clean-,${NVM_TAGS})

all: ${JOBS}
clean: ${CLEAN_JOBS}
.PHONY: all clean ${JOBS} ${CLEAN_JOBS}

${JOBS}: core-%: Dockerfile
	docker build \
	  --build-arg NVM_TAG=$* \
	  --tag dwolla/jenkins-agent-nvm-sbt:$*-SNAPSHOT \
	  .

${CLEAN_JOBS}: clean-%:
	docker rmi dwolla/jenkins-agent-nvm-sbt:$*-SNAPSHOT
