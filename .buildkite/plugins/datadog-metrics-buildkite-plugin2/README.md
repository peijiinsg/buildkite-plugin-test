# DataDog Metrics Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for pushing metrics to DataDog.

## Example

The following pipeline step will push some DataDog metrics based on the exit status of the command

```yaml
steps:
  - command: "exit 0"
    label: "Build all the things"
    plugins:
      - https://github.latitudefinancial.com/Latitude/datadog-metrics-buildkite-plugin#v1.0.0:
          api_key_path: "/latitude/datadog/api-key"
          metric: hello-metrics
          value: 1
          condition: true
          tags:
            - "env:dev"
            - "branch:$BUILDKITE_BRANCH"
```

will push a metric

with tags `"env:dev"`, as well as any tags set as a buildkite meta-data `default_tags`. Note that `plugin-test` is the name of the pipeline.

Similarly, if the command fails as follow:

```yaml
steps:
  - command: "exit 17"
    label: "Build all the things"
    plugins:
      - https://github.latitudefinancial.com/Latitude/datadog-metrics-buildkite-plugin#v1.0.0:
          api_key_path: "/latitude/datadog/api-key"
          tags:
            - "env:DEV"
```

it will push

```
[FAILURE] plugin-test #555 - Build all the things
```

## Configuration

NOTE: Including [buildkite.mk](https://github.latitudefinancial.com/Latitude/cnp-secure-pipeline/blob/master/src/make/buildkite.mk) for use with the `cnp-secure-pipeline`, would automatically define the required buildkite meta-data

### `api_key_path` (optional, string)

The SSM path to the Datadog API key to use for the requests. This defaults to `/latitude/cnp/datadog/api-key`.

### `tags` (optional, string array)

Tags to send to Datadog.

To use environment variables in your tags, you will need to escape the parameterised variable as per https://buildkite.com/docs/agent/v3/cli-pipeline.

### Buildkite meta-data

#### `default_tags` (required, csv)

Default tags should be sent as CSV in the form "key1:value1,key2:value2"

## Developing

### Running tests

```bash
docker-compose run --rm tests
```

### Running linter

```bash
docker-compose run --rm lint
```
