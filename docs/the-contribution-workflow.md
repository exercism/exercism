## Contributing to Exercism

Open source contributions can be intimidating! As you're looking around, wondering where to dive in, you might think everyone _else_ knows what's going on in the code base, or has better grasp of the language, or seems to be well known around the project.

As a total beginner, where do you begin?

Right here. This guide will walk you through your first open source contribution.

It's going to target the smallest possible fix (improving documentation), as a "bridge" to more complex contributions later.

First, go take a look at [Contributing to Exercism.io](https://github.com/exercism/exercism.io/blob/master/CONTRIBUTING.md#submitting-code-changes)

If not all of that makes sense to you, keep reading. This is for you.


## Table of Contents

- [Find the right contribution](#find-the-right-contribution)
- [Claiming that contribution](#claiming-that-contribution)
- [Working on the code](#working-on-the-code)
- [Submitting your contribution](#submitting-your-contribution)

# Find the right contribution

As mentioned in the contribution guideline, take a look at the [open issues](https://github.com/exercism/exercism.io/issues). There's a lot here, so you might want to filter by `label:"good first patch"` [(like this)](https://github.com/exercism/exercism.io/labels/good%20first%20patch).

Read through the conversations, and decide if it seems like a good fit.

(Another good place to start: [Finding your way](https://github.com/exercism/docs/blob/master/finding-your-way.md))

As an example, I (person who is writing this guide) went through the above steps and found [this conversation](https://github.com/exercism/exercism.io/issues/3252). I thought "I think I can do that", and decided I wanted to.

# Claiming that contribution

Why would you claim an issue?

It will make sure that you're not duplicating someone else's work, or someone else doesn't start duplicating yours. It also helps the project maintainers know what is being worked on. It's hard to over communicate, so you should certainly claim an issue.

Different projects have different ways of "claiming" an issue, but for Exercism, just drop a comment in there, [like so](https://github.com/exercism/exercism.io/issues/3252#issuecomment-312428804).

If it makes sense, someone from the project will jump in, offer some guidance, and (generally) be pleased with your offer.

# Working on the code

OK, you've got an issue, you've got approval to work on it. Now's the fun part.

Now you need to get Exercism running on your local machine.

Setup can be challenging, but fortunately, Exercism has great docs for [walking you through this process](https://github.com/exercism/exercism.io/blob/master/docs/setting-up-local-development.md).

If you can work through the steps in the above guide, great! If you're still not positive what to do, read on.

1. Fork the Exercism repository to your github account.

The URL for the repo looks like https://github.com/exercism/exercism.io

You want it to be https://github.com/YOUR-USERNAME-HERE/exercism.io

"[Forking](https://help.github.com/articles/fork-a-repo/)" is how we do that.



![Forking the Repo](/docs/img/beginner_contribution_fork_repo.gif)

Go to https://github.com/exercism/exercism.io, and click "Fork". When it asks "Where should we fork this repository", choose your user account.

2. Clone down the forked repo

Now, from the repo in your account (the URL should be something like https://github.com/YOUR-USERNAME-HERE/exercism.io)

Click "clone or download" and get the URL for cloning it.

In your terminal, run

```shell
git clone <url from github here>
```

It might look something like this:

![Cloning down the repo](/docs/img/beginner_contribution_clone_repo.gif)

Once it finishes downloading, change into the new directory, and congrats! You've got Exercism cloned down to your machine!


3. Track the original Exercism repo

As you might expect, the Exercism codebase changes constantly. It's important, therefore, to make sure you can easily stay up-to-date with new changes.

To do that, you have to add the original Exercism repo as one of your remotes.

To show what will happen, fell free to run `git remote -v` in your terminal.

It should show something like this:

```shell
$ git remote -v
origin	git@github.com:josh-works/exercism.io.git (fetch)
origin	git@github.com:josh-works/exercism.io.git (push)
```

So, we want to add another "remote", pointing to https://github.com/exercism/exercism.io.git

To do that, run:

`git remote add upstream https://github.com/exercism/exercism.io.git`

Now, when you run `git remote -v`, you should have _two_ remotes:

```shell
$ git remote -v

origin	git@github.com:josh-works/exercism.io.git (fetch)
origin	git@github.com:josh-works/exercism.io.git (push)
upstream	https://github.com/exercism/exercism.io.git (fetch)
upstream	https://github.com/exercism/exercism.io.git (push)
```

This is perfect. Now, go update your current repo with the 'upstream' repo, just run

```shell
git pull upstream master
```

And you'll update your master branch to the most current version from Exercism.


# Working on the code

OK, you've done quite a bit of work to get set up and ready to make your contributions.

Next, you need to check out a new branch, and do the work.

The name of the branch I'm working on right now, as I write this guide, is `contribution_for_beginners`.

You might pick something similarly descriptive of the feature you're working on.

So, with your checked out branch, do your work and make commits as usual. Add files, add descriptive commit messages, etc.



# Submitting your contribution

Once you've made your changes, you are ready to do one of two things:

1. Submit them.
2. Publish them for feedback

The good news is the process for both of these steps is the same.

You're going to make a "pull request", against the Exercism repo.

[Here's a quick explanation/guide for pull requests](https://yangsu.github.io/pull-request-tutorial/), if you want some extra reading.

## Making your pull request

#### Add and commit your code

This is the normal `git add <file>`, `git commit -m "your commit message"` bit.

#### Fetch the current version of exercism, merge it into your branch

Remember that Exercism is a huge codebase and changes regularly. So, you need to make sure that the code your working with is as up-to-date as possible.

```shell
# check out the master branch
$ git checkout master

# get changes to the exercism repo
$ git fetch upstream master

# merge your changes into your master branch
$ git checkout your_working_branch
$ git rebase -i your_working_branch master
```

_git rebase_ is a tricky thing if it's your first time. (I'm still not good at it.)

It's an alternative to _merge_, and though it's a few more steps, its worth it in the long run, as rebasing keeps the commit log much cleaner.

Here's some guides that might help you through:

- [Keeping A GitHub Fork Updated](https://robots.thoughtbot.com/keeping-a-github-fork-updated)
- [Rewriting history](https://www.atlassian.com/git/tutorials/rewriting-history)
- [Merging vs. Rebasing](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)


Often, once you submit your changes, there might be need for additional changes, based on feedback from the project maintainers.

Once you're ready, make the Pull Request


# Making the Pull Request

I *just* made the pull request (PR) for this guide. You can see the PR [here](https://github.com/exercism/exercism.io/pull/3604).

To make the pull request, push your branch up to your forked version of Exercism.

```shell
$ git push origin <branch_name>
```

Then, navigate to your cloned fork of the Exercism repo, and click the "new pull request" button. (You can change all the details of the pull request after clicking this button)

![Make the Pull Request](/docs/img/beginner_contribution_make_pr.gif)

Make sure to select `exercism/exercism.io`, with `master` as the `base fork`, on the left, and `your_username/exercism.io` as the `head fork` on the right. You can choose to compare whichever branch has your changes on it, either `master` or a different branch you worked on.

If you need to collect feedback on your work, it is convention to label your pull request as a "work in progress", or "wip".

The pull request note is your chance to lay out lots of information about what you're doing, why you did it that way, and all relevant details about the code you're adding/changing.

You can "tie" the pull request to the github issue you claimed above with the syntax outlined [here](https://github.com/blog/1506-closing-issues-via-pull-requests)

This links the PR and issue conversation together.

At this point, you can tag anyone in the project to ask for feedback. Just type `@their_user_name` and they'll be notified.

Based on their feedback, you can go back and forth in discussion, and eventually, remove the "wip" tag and merge your contribution!

There is no need to make a new PR or new branches. New commits will automatically get pushed up to the pull request.








### Additional Support

- [A junior developer’s step-by-step guide to contributing to open source for the first time](https://medium.com/@letakeane/contributing-to-open-source-the-sharks-are-photoshopped-47e22db1ab86)




# Notes from Discussion

It would be incredibly helpful if this outline were extracted and written with first-time contributors in mind:

 - extract this section into a separate file: docs/the-contribution-workflow.md (please use that name, other work (e.g. #3194) is referencing it).
 - elaborate/annotate each action so first-timers can successfully follow the process.
- currently, the flow assumes a contributor knows what "fork", "upstream", "remote", "pull request", "rebase" all mean. Link to existing documentation (ideally documentation that is aimed at first-timers) as much as possible.
- it should be that someone who hasn't contributed on GitHub before can walk through the process and successfully submit a PR, properly.
 - encourage readers to go to our support chat room (Gitter) and/or submit an issue to get assistance. We're here to help!!
