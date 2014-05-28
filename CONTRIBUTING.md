# Contributing to Exercism.io

First of all, **thank you** for helping with Exercism.io!

## Issues

Please file issues on the [GitHub issues
list](https://github.com/exercism/exercism.io/issues) and give as much detail
as possible.

## Features / Pull Requests

This is a prototype, and as such we're quite open to feature experiments. If
you want a feature implemented, the best way to get it done is to submit a
pull request that implements it. Tests would be wonderful.

There are full instructions on getting the app running [in the
README](https://github.com/exercism/exercism.io/blob/master/README.md).

Please try and stick to the [GitHub Ruby Style
Guidelines](https://github.com/styleguide/ruby).

## Creating a new Language Track

Send an email to [kytrinyx@exercism.io](mailto:kytrinyx@exercism.io) and
ask to have a new repository created for the problems in that language.

Each language will need at least 10 problems in order to launch, as well as a
small handful of people who can kick off the nitpicking. These people should
have a good grasp of the styles and idioms in use in that language.

Each problem requires:

- a test suite
- a sample solution that tests the test suite (this doesn't have to be
  considered good code, as it will not be exposed in the application)

Also, the metadata for the problem must exist in
[exercism/x-common](https://github.com/exercism/x-common).

Within the language-specific repository, create a `config.json` file that
lists the the problems in (more or less) increasing levels of difficulty.
It's hard to know at first which problems turn out to be harder than
others, and a best guess is fine.

See the existing [ruby repository](https://github.com/exercism/xruby) for reference.

In addition to making the problems available in the language-specific
repository, the following needs to be added:

1. A help topic: [`lib/redesign/articles/help/setup/$LANGUAGE.md`](https://github.com/exercism/exercism.io/blob/master/lib/redesign/articles/help/setup/)
2. An entry in [`lib/exercism/code.rb`](https://github.com/exercism/exercism.io/blob/master/lib/exercism/code.rb) to define the extension for that language.

Once the language is ready to launch, let me know and I'll include it as a git
submodule in the [Problems API](https://github.com/exercism/x-api).

## Adding a Problem

A problem must have a unique slug. This slug is used as

* the directory name within each language-specific repository
* the entry in `config.json`
* the basename for the metadata files

There are two metadata files that go in the
[x-common](https://github.com/exercism/x-common) repository.

* `<slug>.yml` - contains `blurb`, `source`, and `source_url`.
* `<slug>.md` - contains the long-form description of the exercise

These get sewn into a README that gets delivered with the exercise.

If you are adding an exercise that already exists in another language, then
the metadata files will already be present.

Each language has its own repository, in the exercism GitHub organization. It
is named `x<language>`, e.g.

* [exercism/xruby](https://github.com/exercism/xruby)
* [exercism/xpython](https://github.com/exercism/xpython)

These repositories have directories for each exercise, along with an
`config.json` file which which provides a canonical source of exercises that
are available and active in a particular language, as well as their ordering

An exercise may have supporting files, such as type definitions.

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
