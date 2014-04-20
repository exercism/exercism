# Contributing to Exercism.io

First of all, **thank you** for helping with Exercism.io!

## Issues

Please file issues on the [GitHub issues list](https://github.com/exercism/exercism.io/issues) and give as much detail as possible.

## Features / Pull Requests

If you want a feature implemented, the best way to get it done is to submit a pull request that implements it. Tests would be wonderful.

There are full instructions on getting the app running [in the README](https://github.com/exercism/exercism.io/blob/master/README.md).

Please try and stick to the [GitHub Ruby Style Guidelines](https://github.com/styleguide/ruby).

## Creating a new Language Track

Send an email to kytrinyx@exercism.io and ask to have a new repository created
for the exercises in that language.

Each language will need at least 10 exercises in order to launch, as well as a small handful of people who can kick off the nitpicking. These people should have a good grasp of the styles and idioms in use in that language.

Each exercise requires:

- a test suite
- a sample solution that tests the test suite (this doesn't have to be
  considered good code, as it will not be exposed in the application)

Also, the metadata for the exercise must exist in
[exercism/x-common](https://github.com/exercism/x-common).

Within the language-specific repository, create an `EXERCISES.txt` file that
lists the order of the exercises.

Once the exercises have been implemented, then the repository must be included
as a git submodule in [exercism/x-api](https://github.com/exercism/x-api).

In addition to making the exercises available via `x-api`, the following needs
to be added:

1. A help file: `lib/app/articles/help/setup/$LANGUAGE.md`
,. An entry in `lib/exercism/code.rb` to define the extension for that language.

## Using the CLI Locally

The `~/.exercism.go` configuration file for the CLI contains a field
'hostname' which defaults to 'http://exercism.io'. You can change this to
'http://localhost:4567' to run against your development environment.

If you are also serving exercises locally via `x-api`, you can configure the
exercism.io app to talk to `x-api` locally by exporting an environment
variable:

```bash
$ export EXERCISES_API_URL=http://localhost:9292
```

Thank you again!
:heart: :sparkling_heart: :heart:
