SERVICE_NAME=datadog-metrics-buildkite-plugin

include /usr/local/cicd/make/common.mk
include /usr/local/cicd/make/buildkite.mk

tag:
	@echo "--- Tagging build '$(PROJECT_VERSION)'"
	git tag $(PROJECT_VERSION)

	@echo "--- Pushing tag '$(PROJECT_VERSION)'"
	git push origin $(PROJECT_VERSION)
