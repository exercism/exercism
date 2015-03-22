# Contributing to Exercism.io

First of all, **thank you** for helping with Exercism.io!

There are full instructions on getting the app running [in the
README](https://github.com/exercism/exercism.io/blob/master/README.md).

Please read and abide by the [Code of
  Conduct](https://github.com/exercism/exercism.io/blob/master/CODE_OF_CONDUCT.md).

We're not really sticklers about style in this prototype, and things are
fairly messy, but do try to stick to the [GitHub Ruby Style
Guidelines](https://github.com/styleguide/ruby), it will make it easier to
clean things up later when we know about where this is headed.

## The Ecosystem

Exercism actually consists of several different parts, many of which are in
separate repositories. Most people will be familiar with **the website** where
they have conversations with people about the various exercises, as well as
**the command-line client**, which is used to fetch problems and submit
solutions.

In addition to these, there is the **problems API**, which is what the
command-line client talks to when fetching problems.

For example, if you say `exercism fetch go clock`, then the CLI makes a call
to http://x.exercism.io/problems/go/clock, and then uses that data to create
the files on the user's computer.

* website: https://github.com/exercism/exercism.io (Ruby, JavaScript)
* problems API: https://github.com/exercism/x-api (Ruby)
* command-line client: https://github.com/exercism/cli (Go)

## Languages and Practice Problems

The problems (test suites) for each language are in separate repositories.
This is useful since different people contribute to different languages, and
it allows us to have people manage pull requests and contributions to a
specific language without being overwhelmed by irrelevant issues and tickets.

If you'd like to

* fix inconsistencies in READMEs or test suites
* improve existing problems in existing language tracks
* contribute new problems in existing language tracks
* contribute problems in a new language track

then please see the [Problem API's CONTRIBUTING
guide](https://github.com/exercism/x-api/blob/master/CONTRIBUTING.md).

## Labels

[TODO: explain the various labels as we settle on useful ones]

### Future Roadmap

The focus of the development efforts at the moment are about making the core
experience good: smooth onboarding, rich conversations, high quality feedback,
and getting feedback quickly.

Sometimes we get suggestions for things that would be great, but they're not
part of locking down the core behavior of the app. In this case we'll close
and label it ["future roadmap"](https://github.com/exercism/exercism.io/labels/future%20roadmap)
to make it easy to search for later.

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
