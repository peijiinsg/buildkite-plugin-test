#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "calls datadog api using curl" {
  export DATADOG_API_KEY="foo"
  export BUILDKITE_PIPELINE_SLUG="pipeline"
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_BUILD_ID="build-123"
  export BUILDKITE_BUILD_URL="build-url"
  export BUILDKITE_LABEL="build-label"
  export BUILDKITE_BUILD_NUMBER=200

  _CURL_ARGS="\
-X POST -H Content-type: application/json -d { \
\"title\": \"[SUCCESS] pipeline #200 - build-label\", \
\"text\": \"Build located at build-url\", \
\"priority\": \"normal\", \
\"alert_type\": \"success\", \
\"tags\": [\"env:FOO\",\"source:buildkite\"], \
\"aggregation_key\": \"build-123\" \
} https://api.datadoghq.com/api/v1/events?api_key=foo"
  echo $_CURL_ARGS

  stub aws \
    "ssm get-parameter --name \"/latitude/datadog/api-key\" --with-decryption --query Parameter.Value --output text : echo foo"
  # TODO: This doesn't match currently. Needs tweaking.
  stub curl "$_CURL_ARGS : echo Success"
  stub buildkite-agent \
    "meta-data get \"default_tags\" : echo 'env:FOO'"

  run $PWD/hooks/post-command

  assert_output --partial "Success"
  assert_success

  unstub aws
  unstub buildkite-agent
  #unstub curl
}
