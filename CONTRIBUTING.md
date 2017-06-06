# Contributing to Exercism.io

First of all, **thank you** for helping with Exercism.io!

This contributing guide is specifically about contributing to the exercism.io website codebase. For a guide to the project as a whole check out the [finding your way](https://github.com/exercism/docs/blob/master/finding-your-way.md) guide in the [docs](https://github.com/exercism/docs) repository.

# Table of Contents

* [Code of Conduct](#code-of-conduct)
* [Contributing](#contributing)
* [Submitting Code Changes](#submitting-code-changes)
    - [Git Workflow](#git-workflow)
    - [Issues](#issues)
    - [Good First Patch](#good-first-patch)
    - [Style (Ruby)](#style-ruby)
    - [Style (JavaScript/CSS)](#style-js-css)
    - [Pull Requests](#pull-requests)
* [Roadmap](#roadmap)

## Code of Conduct

Help us keep exercism welcoming. Please read and abide by the [Code of
  Conduct](https://github.com/exercism/exercism.io/blob/master/CODE_OF_CONDUCT.md).

## Submitting Code Changes

These instructions should get you closer to getting a commit into the
repository.

See the [Setting up Local Development guide](docs/setting-up-local-development.md) for more information about how to run exercism.io locally.

### Git Workflow

1. Fork and clone.
1. Add the upstream exercism.io repository as a new remote to your clone.
   `git remote add upstream https://github.com/exercism/exercism.io.git`
1. Create a new branch
   `git checkout -b name-of-branch`
1. Commit and push as usual on your branch.
1. When you're ready to submit a pull request, rebase your branch onto
   the upstream master so that you can resolve any conflicts:
   `git fetch upstream && git rebase upstream/master`
   You may need to push with `--force` up to your branch after resolving conflicts.
1. When you've got everything solved, push up to your branch and send the pull request as usual.

### Issues

We keep track of everything around the repository using GitHub [issues](https://github.com/exercism/exercism.io/issues).

### Good First Patch

We're trying to label issues with "good first patch" if we think that these can be solved
without too much context about exercism.io's codebase or functionality. To find them, you
can do a [search](https://github.com/exercism/exercism.io/labels/good%20first%20patch).

### Style (Ruby)

We have [Rubocop](https://github.com/bbatsov/rubocop) integrated.
It is based on the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide).
Help keep us our code clean by following the style guide.
Run the command `rubocop` to check for any style violations before
submitting pull requests.

### Style (JS/CSS)

If you have any JS or CSS changes, please run `cd frontend && lineman spec-ci` to check for any style violations before submitting pull requests.

### Pull Requests

When submitting a pull request, sometimes we'll ask you to make changes before
we accept the patch.

Please do not close the first pull request and open a second one with these
changes. If you push more commits to a branch that you've opened a pull
request for, it automatically updates the pull request. This is also the case
if you change the history (rebase, squash, amend), and use git push --force to
update the branch on your fork. The pull request points to that branch, not to
specific commits.

## Roadmap

We are currently working on reimagining the Exercism user experience from the ground up.

For details, please see https://github.com/exercism/discussions/issues/113

For more resources see:

* [Git Workflow](https://github.com/exercism/x-common/blob/master/CONTRIBUTING.md#git-basics) in the language track contributor guide
* [How to Squash Commits in a GitHub Pull Request](http://blog.steveklabnik.com/posts/2012-11-08-how-to-squash-commits-in-a-github-pull-request)
