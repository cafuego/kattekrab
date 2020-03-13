# Variables. Yes.
DOCKER=docker
DOCKER_BUILDKIT=0

# The main build recipe.
build:	clean
	DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) $(DOCKER) build \
				--build-arg BRANCH_ENVIRONMENT=$(NODE_ENV) \
				--build-arg VCS_REF=`git rev-parse --short HEAD` \
				--build-arg VCS_URL=`git config --get remote.origin.url | sed 's#git@github.com:#https://github.com/#'` \
				--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
				--build-arg GITHUB_ACTOR=`whoami` \
				--build-arg GITHUB_REPOSITORY=`git config --get remote.origin.url` \
				--build-arg GITHUB_SHA=`git rev-parse --short HEAD` \
		. --file docker/Dockerfile --tag cccomau/kattekrab:local \
		2>&1 | tee buildlog.txt
	@echo "Built a shiny new ccomau/kattekrab:local for you."

clean:
	rm -rf ./buildlog.txt

# Always build, never claim cache.
.PHONY: build
