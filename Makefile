GIT_COMMIT ?= $(shell git rev-parse --short HEAD)
export GIT_COMMIT

.PHONY: build
build:
	docker build -t mixpanel-proxy .

.PHONY: tag
tag: check-git-clean check-git-master-branch
	docker tag mixpanel-proxy luneclimate/mixpanel-proxy
	docker tag mixpanel-proxy luneclimate/mixpanel-proxy:$(GIT_COMMIT)


.PHONY: push
push: check-git-master-branch
	docker push luneclimate/mixpanel-proxy
	docker push luneclimate/mixpanel-proxy:$(GIT_COMMIT)

# Checks if there are uncommitted changes
.PHONY: check-git-clean
check-git-clean:
	@if [ "$(shell git diff-index --quiet HEAD; echo $$?)" != "0" ] ; then \
		echo "There are uncomitted changes. Please remove or commit them."; \
		exit 1; \
    fi;

# Checks if the current branch is master
.PHONY: check-git-master-branch
check-git-master-branch:
	@if [ "$(shell git branch --show-current)" != "master" ] ; then \
		echo "Please ensure to be operating on the master branch"; \
		exit 1; \
    fi;
