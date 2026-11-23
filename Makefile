NVM_TAG ?= $(shell yq '.env.NVM_TAG' .github/workflows/ci.yml)
# The build JDK (11 or 17); its pinned image is read from the CI matrix
BUILD_JDK ?= 11
BUILD_JDK_IMAGE ?= $(shell yq '.jobs.build.strategy.matrix.include[] | select(.build_jdk == $(BUILD_JDK)) | .build_jdk_image' .github/workflows/ci.yml)
TAG := ${NVM_TAG}-build-jdk${BUILD_JDK}-SNAPSHOT

all: build
.PHONY: all build clean

build: Dockerfile
	docker buildx build \
	  --platform linux/arm64,linux/amd64 \
	  --build-arg NVM_TAG=${NVM_TAG} \
	  --build-arg BUILD_JDK_IMAGE=${BUILD_JDK_IMAGE} \
	  --tag dwolla/jenkins-agent-nvm-sbt:${TAG} \
	  .

clean:
	docker image rm --force dwolla/jenkins-agent-nvm-sbt:${TAG}
