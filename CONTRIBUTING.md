# Contributing to Exercism.io

First of all, **thank you** for helping with Exercism.io!

## Issues

Please file issues on the [GitHub issues
list](https://github.com/exercism/exercism.io/issues) and give as much detail
as possible.

## Features

This is a prototype, and as such we're quite open to feature experiments. If
you want a feature implemented, the best way to get it done is to submit a
pull request that implements it. Tests would be wonderful.

There are full instructions on getting the app running [in the
README](https://github.com/exercism/exercism.io/blob/master/README.md).

Please read and abide by the [Code of
  Conduct](https://github.com/exercism/exercism.io/blob/master/CODE_OF_CONDUCT.md).

We're not really sticklers about style in this prototype, and things are fairly messy,
but do try to stick to the [GitHub Ruby Style Guidelines](https://github.com/styleguide/ruby),
it will make it easier to clean things up later when we kind of know what we're doing.

## Pull Requests

When submitting a pull request, sometimes we'll ask you to make changes before
we accept the patch.

Please do not close the first pull request and open a second one with these
changes. If you push more commits to a branch that you've opened a pull
request for, it automatically updates the pull request. This is also the case
if you change the history (rebase, squash, amend), and use git push --force to
update the branch on your fork. The pull request points to that branch, not to
specific commits.

## Workflow

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

For more resources see:

* [Git Workflow](http://help.exercism.io/git-workflow.html) in the exercism.io documentation
* [How to Squash Commits in a GitHub Pull Request](http://blog.steveklabnik.com/posts/2012-11-08-how-to-squash-commits-in-a-github-pull-request)

## Languages and Practice Problems

If you'd like to

* fix inconsistencies in READMEs or test suites
* improve existing problems in existing language tracks
* contribute new problems in existing language tracks
* contribute problems in a new language track

then please see the [Problem API's CONTRIBUTING
guide](https://github.com/exercism/x-api/blob/master/CONTRIBUTING.md).

Thank you again!
:heart: :sparkling_heart: :heart:
