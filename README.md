# `cloud_repro`
This is a repro case for a problem I am having with multirun:
https://bazelbuild.slack.com/archives/CD4MDG09Z/p1711041846373839

## Repro steps

We do all of our work inside of a Docker container, so this repro case includes a Dockerfile and
scripts to work with it.

1. Run `scripts/setup.sh` to build and start the container

1. Run `scripts/shell.sh` to get a shell inside the container

1. Run `bazel run //http_server` to run WITHOUT multirun. You should see something like this:

    ````
    * Running on all addresses (0.0.0.0)
    * Running on http://127.0.0.1:5000
    * Running on http://172.17.0.2:5000
    Press CTRL+C to quit
    ````

1. Run` bazel run //http_server:multirun` to run WITH multirun. You should see an error like this:

    ````
    from opentelemetry.instrumentation.flask import FlaskInstrumentor
    ModuleNotFoundError: No module named 'opentelemetry.instrumentation'
    ````
