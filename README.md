# dxw repo audit

An application for checking and facilitating adherence to the dxw standard contributing guidelines across all of dxw's repositories.

Lists all non-archived repos, checks for the existence of a CODE_OF_CONDUCT.md and a CONTRIBUTING.md, and allows opening a pull request on the target repository to add any of those files if they're missing.

## Getting started

1. copy `/.env.example` into `/.env.development.local`.

  Our intention is that the example should include enough to get the application started quickly. If this is not the case, please ask another developer for a copy of their `/.env.development.local` file.

TODO: Add getting started steps

## Running the tests

```bash
bundle exec rspec
```

## Running Brakeman

Run [Brakeman](https://brakemanscanner.org/) to highlight any security vulnerabilities:
```bash
brakeman
```

To pipe the results to a file:
```bash
brakeman -o report.text
```

## Making changes

When making a change, update the [changelog](CHANGELOG.md) using the
[Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format. Pull
requests should not be merged before any relevant updates are made.

## Releasing changes

When making a new release, update the [changelog](CHANGELOG.md) in the release
pull request.

## Architecture decision records

We use ADRs to document architectural decisions that we make. They can be found
in doc/architecture/decisions and contributed to with the
[adr-tools](https://github.com/npryce/adr-tools).

## Managing environment variables

We use [Dotenv](https://github.com/bkeepers/dotenv) to manage our environment variables locally.

The repository will include safe defaults for development in `/.env.example` and for test in `/.env.test`. We use 'example' instead of 'development' (from the Dotenv docs) to be consistent with current dxw conventions and to make it more explicit that these values are not to be committed.

To manage sensitive environment variables:

1. Add the new key and safe default value to the `/.env.example` file eg. `ROLLBAR_TOKEN=ROLLBAR_TOKEN`
2. Add the new key and real value to your local `/.env.development.local` file, which should never be checked into Git. This file will look something like `ROLLBAR_TOKEN=123456789`

## Access

Currently this application is not deployed anywhere.

## How to generate new VCR cassettes

To generate new VCR cassettes, which requires making calls the GitHub API, you’ll need to provide a GitHub personal access token as `GITHUB_ACCESS_TOKEN` in `.env.test.local`.

## Source

This repository was bootstrapped from
[dxw's `rails-template`](https://github.com/dxw/rails-template).
