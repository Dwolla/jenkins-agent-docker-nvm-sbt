CORE_TAGS := sha-a9c907d-core-4.13.2-1-jdk8-7b03219 sha-a9c907d-core-4.13.2-1-jdk11-7b03219
JOBS := $(addprefix core-,${CORE_TAGS})
CHECK_JOBS := $(addprefix check-,${CORE_TAGS})
CLEAN_JOBS := $(addprefix clean-,${CORE_TAGS})

all: ${CHECK_JOBS} ${JOBS}
check: ${CHECK_JOBS}
clean: ${CLEAN_JOBS}
.PHONY: all check clean ${JOBS} ${CHECK_JOBS} ${CLEAN_JOBS}

${JOBS}: core-%: Dockerfile
	docker build \
	  --build-arg CORE_TAG=$* \
	  --tag dwolla/jenkins-agent-nvm-sbt:$*-SNAPSHOT \
	  .

${CHECK_JOBS}: check-%:
	grep --silent "^          - $*$$" .github/workflows/ci.yml

${CLEAN_JOBS}: clean-%:
	docker rmi dwolla/jenkins-agent-nvm-sbt:$*-SNAPSHOT
