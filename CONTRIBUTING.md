# Contributing to Exercism.io

First of all, **thank you** for helping with Exercism.io!

We are working to improve this document, and if you find any part of it confusing, or if you can't figure out how to get started with something, then rest assured it's not you, it's us! Please open up a new issue to describe what you were hoping to contribute with, and what you're wondering about, and we'll figure out together how to improve the documentation.

* [The Ecosystem](#the-ecosystem)
* [Get Set Up](#setup)
    - [Console](#console)
    - [Testing](#testing)
    - [Frontend Development Setup](#frontend-development-setup)
    - [Deployment](#deployment)
* [Write Some Code](#write-some-code)
    - [Workflow](#workflow)
    - [Issues](#issues)
    - [Good First Patch](#good-first-patch)
    - [Style](#style-rubyrails)
    - [Pull Requests](#pull-requests)
* [Roadmap](#future-roadmap)

## Code of Conduct

Help us keep exercism welcoming. Please read and abide by the [Code of
  Conduct](https://github.com/exercism/exercism.io/blob/master/CODE_OF_CONDUCT.md).

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

* website: https://github.com/exercism/exercism.io (Ruby using Sinatra, JavaScript using Angular)
* problems API: https://github.com/exercism/x-api (Ruby using Sinatra)
* command-line client: https://github.com/exercism/cli (Go)

### Languages and Practice Problems

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

## Setup

If you'd like to do work on the exercism.io app, then you'll need to have it
running locally.

### Prerequisites

For working on the backend you'll need both Ruby and PostgreSQL. Frontend development uses Node.js.

To install Ruby, check out [RVM](https://rvm.io), [rbenv](https://github.com/sstephenson/rbenv) or [ruby-install](https://github.com/postmodern/ruby-install).

PostgreSQL can be installed with [Homebrew](http://brew.sh) on Mac OS X: `brew install postgresql`
If you're on a Linux system with apt-get then run: `apt-get install postgresql postgresql-contrib`

Install Node.js and npm on Mac OS X with Homebrew:  `brew install node`
On other systems see the [Node.js docs](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

### GitHub OAuth

In order to be able to log into your local version of the application, you will
need to create some keys on GitHub that the app can talk to.

Go to https://github.com/settings/applications/new and enter the following:

* Application name: You can name it whatever you want. I have _Exercism (Dev)_.
* Homepage URL: http://localhost:4567
* Authorization callback URL: http://localhost:4567/github/callback

Click _Register application_, and you'll see something like this:

![](/docs/oauth-client-secret.png)

Later you will add the **Client ID** and **Client Secret** to a configuration file.

### The Code

If you're unfamiliar with git and GitHub, don't worry. We'll gladly help you out if you get stuck. GitHub also has some [helpful guides](https://guides.github.com) for getting started.

First, you need to get ahold of the code, so you have a copy of it locally that you can make changes to.

* [Fork](https://github.com/exercism/exercism.io/fork) this codebase to your own GitHub account.
* Clone your fork, and change directory into the root of the exercism.io project.

### Configuration

* If you use a Ruby version manager such as RVM, rbenv or chruby, then: `cp .ruby-version.example .ruby-version`
* Copy the environment config: `cp config/env .env`
* Open `.env` and add the **Client ID** and **Client Secret** from the previous GitHub OAuth steps.

All the commented out values in `.env` can be left alone for now.

You don't need to fill in the EXERCISES_API value unless you're going to be working on the x-api codebase.

### Dependencies

Next, make sure all the application dependencies are installed:

* Install gems with: `bundle install`

### Data

Finally, set up the database. This means both creating the underlying database, and migrating so that it
has all the correct tables. Also runs a script to add fake data, so there are things to click on and look at while working on the app.

First of all, copy the database config file:

* `cp config/database.example.yml config/database.yml`

Update any settings (like the port your database runs on) as needed. You can now set up the database for development:

* Do all of it in one go: `rake db:from_scratch`

Please note that this will call `psql`, and `createdb`. If you need to set PostgreSQL parameters like the user and/or database name to use during setup, set `PGUSER` and/or `PGDATABASE` environment values respectively. Example: `PGUSER=pgsql PGDATABASE=postgres rake db:from_scratch`

Alternatively (or to debug if the above blows up), do it one-by-one:

* Create the PostgreSQL database: `rake db:setup`
* Run the database migrations: `rake db:migrate`
* Fetch the seed data: `rake db:seeds:fetch`
* Seed the database: `rake db:seed`

The setup task will create a PostgreSQL user called exercism with super user permissions.
If you want to avoid this you may create a user manually and add the needed extensions manually as well.

The seed data gives you a bunch of fake user accounts with submissions in multiple languages as well
as fake comments. In development mode there is an "Assume" menu item to the far right of the
nav bar. This will let you easily assume different fake identities to see the site
from their perspective.

### Run The Application

* Start the server with: `foreman s -p 4567`
* Sometimes you need to: `bundle exec foreman s -p 4567`
* Then you can access the local server at [localhost:4567](http://localhost:4567).
* You can log in as a test user using the `assume` dropdown menu on the top right of the page without creating any new user for the app.

### Console

There's a script in `bin/console` that will load pry with the exercism environment loaded.
This will let you poke around at the objects in the system, such as finding users and changing
things about submissions or comments, making it easier to test specific things.

```ruby
user = User.find_by_username 'whatever'
user.submissions
```

### Testing

1. Create and migrate a test database: `RACK_ENV=test rake db:setup db:migrate`
1. Run the test suite: `rake` or `rake test`

To run a single test suite, you can do so with:

```bash
ruby path/to/the_test.rb
```

If it complains about dependencies, then either we forgot to require the correct dependencies (a distinct possibility), or we are dependening on a particular tag of a gem installed directly from GitHub (this happens on occasion).

If there's a git dependency, you can do this:

```bash
bundle exec ruby path/to/the_test.rb
```

For the require, you'll need to figure out what the missing dependency is. Feel free to [open a GitHub
issue](https://github.com/exercism/exercism.io/issues). It's likely that someone familiar with the codebase will be able to identify the problem immediately.

#### Test Order

The tests are run in a randomized order by default. If you have an
intermittent failure, it could be useful to seed the test suite with
a specific value, in order to reproduce the test run.

When running minitest directly, you can pass the seed value:

```
ruby path/to/the_test.rb --seed 1234
```

If running the entire test suite with rake, then you need to pass the options
as an environment variable:

```
TESTOPTS="--seed=44377" rake test
```

#### Code Coverage

To enable code coverage run:

```bash
COVERAGE=1 rake test
```

Browse the results located in `coverage/index.html`

### Frontend Development Setup

[Lineman](http://linemanjs.com) watches for file changes and compiles them automatically. It is not
required to be running for the server to run though.

* Install Lineman with: `npm install -g lineman`
* To run: `cd frontend` and start Lineman with `lineman run`

#### SCSS

* Start Compass with: `compass watch`
* To compile: `compass compile`

For CSS we are using Sass (with `.scss`). Feel free to use [Bootstrap 3](http://getbootstrap.com) components and mixins. Or if you want to use even more mixins you can use [Compass](http://compass-style.org/reference/compass/). Structurewise we try to separate components, mixins and layouts. Where layouts should be a single page (using an HTML id as a selector) and components should be reusable partials, which can look different by layout.

You can find the Compass configuration in `config.rb` in the project's root directory.

#### Styleguide

Our styleguide is under [/styleguide](http://exercism.io/styleguide) and built with [KSS](https://github.com/kneath/kss), which enables you to write examples to `*.scss` files.

### Deployment

Let Heroku know that Lineman will be building our assets. From the command line:
```bash
heroku config:set BUILDPACK_URL=https://github.com/testdouble/heroku-buildpack-lineman-ruby.git
```

## Write Some Code

These instructions should get you closer to getting a commit into the
repository.

### Workflow

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

We keep track of everything around the repository using Github [issues](https://github.com/exercism/exercism.io/issues).

### Good First Patch

We're trying to label issues with "good first patch" if we think that these can be solved
without too much context about exercism.io's codebase or functionality. To find them, you
can do an [organization-wide search](https://github.com/search?utf8=%E2%9C%93&q=is%3Aopen+label%3A%22good+first+patch%22+user%3Aexercism).

### Labels

[TODO: explain the various labels as we settle on useful ones]

### Style (Ruby/Rails)

We have [Rubocop](https://github.com/bbatsov/rubocop) integrated.
It is based on the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide).
Help keep us our code clean by following the style guide.
Run the command `rubocop` to check for any style violations before
submitting pull requests.

### Pull Requests

When submitting a pull request, sometimes we'll ask you to make changes before
we accept the patch.

Please do not close the first pull request and open a second one with these
changes. If you push more commits to a branch that you've opened a pull
request for, it automatically updates the pull request. This is also the case
if you change the history (rebase, squash, amend), and use git push --force to
update the branch on your fork. The pull request points to that branch, not to
specific commits.

## Future Roadmap

The focus of the development efforts at the moment are about making the core
experience good: smooth onboarding, rich conversations, high quality feedback,
and getting feedback quickly.

Sometimes we get suggestions for things that would be great, but they're not
part of locking down the core behavior of the app. In this case we'll close
and label it ["future roadmap"](https://github.com/exercism/exercism.io/labels/future%20roadmap)
to make it easy to search for later.

For more resources see:

* [Git Workflow](http://help.exercism.io/git-workflow.html) in the exercism.io documentation
* [How to Squash Commits in a GitHub Pull Request](http://blog.steveklabnik.com/posts/2012-11-08-how-to-squash-commits-in-a-github-pull-request)
