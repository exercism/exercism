# Contributing to Exercism.io

First of all, **thank you** for helping with Exercism.io!

We are working to improve this document, and if you find any part of it confusing, or if you can't figure out how to get started with something, then rest assured it's not you, it's us! Please open up a new issue to describe what you were hoping to contribute with, and what you're wondering about, and we'll figure out together how to improve the documentation.

* [Code of Conduct](#code-of-conduct)
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
* [Exercism.io Web Structure](#exercism-web-structure)
    - [Core Directories](#core-directories)
    - [Additional Directories](#additional-directories)
* [Roadmap](#future-roadmap)

## Code of Conduct

Help us keep exercism welcoming. Please read and abide by the [Code of
  Conduct](https://github.com/exercism/exercism.io/blob/master/CODE_OF_CONDUCT.md).

## The Ecosystem

Exercism consists of two main parts:

- **the website** - where the conversations happen (this repository)
- **the command-line interface (CLI)** - to fetch exercises and submit solutions [exercism/cli](https://github.com/exercism/cli)

Behind the scenes we also have:

- **language tracks** - one repository per language [see list](https://github.com/exercism/x-api/tree/master/tracks)
- **problem metadata** - a shared repository for all languages [exercism/x-common](https://github.com/exercism/x-common)
- **the problems API** - serves the exercise data [exercism/x-api](https://github.com/exercism/x-api)
- **rikki- the robot** - provides automated feedback on certain exercises [exercism/rikki](https://github.com/exercism/rikki)

### Contributing

We curate issues that we think are good for starting out into [exercism/todo](https://github.com/exercism/todo/labels/start-here).

If you want to work on the exercism.io website codebase, then continue reading this guide.

To contribute to one of the language tracks, check out the [Language Track Guide](https://github.com/exercism/x-common/blob/master/CONTRIBUTING.md).

For details about working with the problems API, check out the [Problems API Guide](https://github.com/exercism/x-api/blob/master/CONTRIBUTING.md).

## Setup

This section walks you through getting the exercism.io app running locally.

### Prerequisites

Backend:

- Ruby
- PostgreSQL

Frontend:

- Node.js

To install Ruby, check out [RVM](https://rvm.io), [rbenv](https://github.com/sstephenson/rbenv) or [ruby-install](https://github.com/postmodern/ruby-install).

PostgreSQL can be installed with [Homebrew](http://brew.sh) on Mac OS X: `brew install postgresql`
If you're on a Linux system with apt-get then run: `apt-get install postgresql postgresql-contrib`

Install Node.js and npm on Mac OS X with Homebrew:  `brew install node`
On other systems see the [Node.js docs](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

### GitHub OAuth

If you seed your local database with fake users, then you can use these to "fake login" as
one of them. There will be a dropdown with identities that you can assume in development mode.

If you want to actually work on the login flow, or if you want to log in as yourself, then
you will need keys on GitHub that the app can talk to.

Go to https://github.com/settings/applications/new and enter the following:

* Application name: You can name it whatever you want, e.g. _Exercism (Dev)_.
* Homepage URL: http://localhost:4567
* Authorization callback URL: http://localhost:4567/github/callback

Click _Register application_, and you'll see something like this:

![](/docs/oauth-client-secret.png)

Hang on to those. You'll need to add the **Client ID** and **Client Secret** to a
configuration file in just a moment.

### The Code

If you're unfamiliar with git and GitHub, don't worry. We'll gladly help you out if you get stuck. GitHub also has some [helpful guides](https://guides.github.com) for getting started.

First, you need to get ahold of the code, so you have a copy of it locally that you can make changes to.

* [Fork](https://github.com/exercism/exercism.io/fork) this codebase to your own GitHub account.
* Clone your fork, and change directory into the root of the exercism.io project.

### Configuration

In most cases, it is easiest to run the `bin/setup` script to automatically setup the defaults for the application. Make sure you have PostgreSQL running in the background.

The script will:

* setup the `.ruby-version` file for your Ruby version manager such as RVM, rbenv or chruby
* copy the environment config to `.env`
* run bundler to install the required gems
* create the development database using the credentials in `config/database.yml`
* download and seed the database with a good starting set of data
* create the test database
* run the test suite

Then you'll need to:

* Open `.env` and add the **Client ID** and **Client Secret** from the previous GitHub OAuth steps.

All the commented out values in `.env` can be left alone for now.

You don't need to fill in the EXERCISES_API value unless you're going to be working on the x-api codebase.

### Data

If you ran `bin/setup` you should be all set.

You can easily reset an existing database to its original state and add the fake data in one step:

* `rake db:reseed`

If you need to set PostgreSQL parameters like the user and/or database name to use during setup, set `PGUSER` and/or `PGDATABASE` environment values respectively. Example: `PGUSER=pgsql PGDATABASE=postgres rake db:reseed`

#### Troubleshooting

Note that you may have trouble running commands like `rake` or `pry` if your system has a different version of those gems than the Gemfile. In that case, you will need to prepend those commands with `bundle exec` so that bundler will execute that command in the context of the project's gems rather than your system's gems. If you would like to learn more about this topic and how to alias `bundle exec` (if you don't like typing it out each time), see [this article by Thoughtbot](https://robots.thoughtbot.com/but-i-dont-want-to-bundle-exec).

To debug the database setup, do it step-by-step:

* Create the PostgreSQL database: `rake db:setup`
* Run the database migrations: `rake db:migrate`
* Fetch the seed data: `rake db:seeds:fetch`
* Seed the database: `rake db:seed`

If you are having 'PG::Connection ...' or 'Peer authentication failed for user ...' issues you can follow these steps (this is assuming that you modified the database.yml file and your changes are not being accessed properly. Anywhere that it is stated "PGUSER=postgres" replace "postgres" with your specified username that you use for your postgresql databases):

* Create the PostgreSQL database (this will prompt you to input a password allowing you to authenticate and create your databases that are specified in your database.yml file): `PGUSER=postgres rake db:create`
* Run the database migrations: `rake db:migrate`
* Fetch the seed data: `rake db:seeds:fetch`
* Seed the database: `rake db:seed`

The setup task will create a PostgreSQL user called exercism with super user permissions.
If you want to avoid this you may create a user manually and add the needed extensions manually as well.

The seed data gives you a bunch of fake user accounts with submissions in multiple languages as well
as fake comments. In development mode there is an "Assume" menu item to the far right of the
nav bar. This will let you easily assume different fake identities to see the site
from their perspective.

You may need to edit the `config/database.yml` file to specify non-default values. If you do, please edit (or create) a `.git/info/exclude` file so that your changes don't get committed. Unfortunately we have to commit the database.yml file, because heroku no longer creates a default one.

Note that if you installed PostgreSQL on OS X with [Postgres.app](http://postgresapp.com/), you'll need to
[configure your `$PATH`](http://postgresapp.com/documentation/cli-tools.html) in order for
the database setup to complete successfully. `bin/setup` relies on PostgreSQL command line tools
and as Postgres.app does not automatically add the application `bin` directory to your `$PATH`,
you'll need to do this manually.

### Run The Application

* Start the server with: `foreman s -p 4567`
* Sometimes you need to: `bundle exec foreman s -p 4567` (see [Troubleshooting](#troubleshooting) above)
* Then you can access the local server at [localhost:4567](http://localhost:4567).
* You can log in as a test user using the `assume` dropdown menu on the top right of the page without creating any new user for the app.

To setup seed data to test out the application locally, use the rake
tasks provided. You can get a list of all the rake tasks by running:

    bundle exec rake -T

To setup the seed data locally, run:

    bundle exec rake db:seeds:fetch
    bundle exec rake db:seed

The first command fetches the seed file and places it under the `db/`
folder as `seeds.sql`. Note that if you're deploying the application to
Heroku, `db:seed` task might fail since the database config file won't
contain the necessary details to access the database. To work around the
problem, there's a task `db:heroku_seed` that can be used.


### Running The Application In A Vagrant Environment
_The following assumes your Vagrantfile is configured to forward port 3000 to 3030, adjust the port number to suit your environment_

If you are using a different port than 3000 to forward outside of your Vagrant environment you will need to go into `Procfile_Vagrant` and adjust the port number that applies to your needs.

* Copy the Vagrant Procfile example `cp Procfile_Vagrant.example Procfile_Vagrant`
* Start the server with: `foreman s -f Procfile_Vagrant` (the `-f` explicitly states which Procfile to use and we don't want to use the original Procfile in our vagrant environments)
* Sometimes you need to: `bundle exec foreman s -f Procfile_Vagrant`
* Then you can access the local server at [localhost:3030](http://localhost:3030).
* You can log in as a test user using the `assume` dropdown menu on the top right of the page without creating any new user for the app.

_Again this is assuming you are forwarding port 3000 to 3030 in your Vagrantfile, adjust accordingly to your environment_

### Console

There's a script in `bin/console` that will load pry with the exercism environment loaded. You may need to run this file as `bundle exec bin/console` (see [Troubleshooting](#troubleshooting) above).
This will let you poke around at the objects in the system, such as finding users and changing
things about submissions or comments, making it easier to test specific things.

```ruby
user = User.find_by_username 'whatever'
user.submissions
```

### Testing

The test suite is comprised of various checks to ensure everything is working and styled as expected.

Before any tests can be run, create and migrate a test database: `RACK_ENV=test bundle exec rake db:setup db:migrate`

The entire test suite can then be run with `bundle exec rake test:everything` or just `bundle exec rake` since `test:everthing` is the default Rake task.

The current checks include:

- [MiniTest](https://github.com/seattlerb/minitest) `rake test` or `rake test:minitest` - Ruby unit and feature tests
- [RuboCop](https://github.com/bbatsov/rubocop) - `rake rubocop` - Ruby style enforcement
- [Lineman Spec](http://linemanjs.com/) - `rake test:lineman` - Front-end tests

To run a single Ruby test, you can do so with:

```bash
ruby path/to/the_test.rb
```

If it complains about dependencies, then either we forgot to require the correct dependencies (a distinct possibility), or we are depending on a particular tag of a gem installed directly from GitHub (this happens on occasion).

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

Lineman will compile your javascripts when you run `lineman run`, but before
committing your code, make sure everything is compiled using:

```bash
cd frontend && lineman build
```

#### SCSS

We use [Compass](http://compass-style.org/) for compiling Sass files.
During development, you can run the compass watcher to keep your compiled CSS files up to date as changes are made.

```bash
bundle exec compass watch
```

Before committing, tell `compass` to compile the stylesheets for production use.

```bash
bundle exec compass compile --production
```

For CSS we are using Sass (with `.scss`). Feel free to use [Bootstrap 3](http://getbootstrap.com) components and mixins. Or if you want to use even more mixins you can use [Compass](http://compass-style.org/reference/compass/). Structurewise we try to separate components, mixins and layouts. Where layouts should be a single page (using an HTML id as a selector) and components should be reusable partials, which can look different by layout.

You can find the Compass configuration in `config.rb` in the project's root directory.

#### Styleguide

Our styleguide is under [/styleguide](http://exercism.io/styleguide) and built with [KSS](https://github.com/kneath/kss), which enables you to write examples to `*.scss` files.

### Deployment

Let Heroku know that Lineman will be building our assets. From the command line:
```bash
heroku config:set BUILDPACK_URL=https://github.com/testdouble/heroku-buildpack-lineman-ruby.git
```

#### Live deployment

Live deployment of changes is done periodically by @kytrinyx

To see which version is currently live visit http://exercism.io/version

This will return a json string that looks like this:
```json
{"repository":"https://github.com/exercism/exercism.io","contributing":"https://github.com/exercism/exercism.io/blob/master/CONTRIBUTING.md","build_id":"0ad66d9"} 
```
The "build_id" is the git id of the revision that is live, which you can find in the list of commits https://github.com/exercism/exercism.io/commits/master . Any commits above that in the list are still be waiting to be released.   
You can also go directly to the commit by replacing \[build_id\] in: https://github.com/exercism/exercism.io/commit/[build_id] with the hex value from the json above.

Whenever a new version is released a message will appear in the sidebar of: https://gitter.im/exercism/dev  This is done via a Heroku webhook to a Gitter api endpoint. (You probably don't need to know this.)


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

We keep track of everything around the repository using GitHub [issues](https://github.com/exercism/exercism.io/issues).

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

## Exercism Web Structure

### Intro

Exercism is built with the [Sinatra](https://github.com/sinatra/sinatra) web framework.
If you haven't heard of it, definitely check it out. It's a lightweight web framework for Ruby.

Exercism seems to follow what some may call an MVP (Model-View-Presenter) architecture.
Read more about that [here](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter).

### Core Directories

#### API

API contains routes which are used by the JavaScript frontend and the [CLI](https://github.com/exercism/cli).
The routes here are similar to the one's in `app/` in that they're individual Sinatra apps that inherit from the Core API route (`api/v1/routes/core.rb`).
If you add a route, it needs to be added to `api/v1/routes.rb` and `api/v1/v1.rb`.

#### App (Routes, Presenters, Helpers and Views)

App is the user facing side of Exercism.
It handles logging in (and other functions), making calls out to the database to store or get information,
structuring HTML (that can later be styled), etc.

**Helpers** can be anything that *helps* presentation of data. For Exercism, these are things like:
wrappers for Markdown and Syntax Highlighting parsers, session handling, etc.
Helpers are defined in individual modules under `app/helpers/*`.
The full list of helpers is in `app/helpers.rb`, and if you add a new helper, this file needs to be edited.
The convention is `ClassName: 'filename'`.

**Presenters** are for showing information that would be beneficial to users or the views but maybe not the best way to store data.
For example, in Exercism, most times are stored in UTC (generally most servers store time this way) but... users might want to see times in their own timezone.
Presenters can take relevant information (like showing comment notifications on the dashboard) and transform it to be more personal.
This convention hasn't been strictly enforced so that description varies between presenters.
Presenters are defined in individual classes/modules under `app/presenters/*`.
The presenters are loaded into the app in the `app/presenters.rb` file, and if you add a presenter, it needs to be added to that file.
The convention is `ClassName: 'filename'`.

**Routes** in Sinatra are kind of like a combination of routes and controllers in Rails.
Each route file contains an individual Sinatra app that inherits some behavior from `Core` (found in `app/routes/core.rb`).
In a route file, you can specify endpoints (like `exercism.io/login`) and define how the app should respond (i.e. accept some credentials and log the user in or handle errors accordingly).
Routes are defined in individual modules under `app/routes/*`.
The route files are loaded into the app with the `app/routes.rb` file, and if you add a route file, it needs to be added to that file.
The convention is `ClassName: 'filename'`.
Routes are unique in that you'll also have to update the main `app.rb` with the new app info.
The convention is `Routes::ClassName`.

**Views** are a collection of templates that create html.
Templates are a way to embed Ruby in your views so that you can serve up information,
iterate over items without repeating yourself (like creating tables of data), etc.
The templating engine that Exercism uses is [ERB](https://en.wikipedia.org/wiki/ERuby).

#### Frontend (JavaScript, Custom Directives, Bootstrap, etc)

The client side is mostly written in CoffeeScript and uses frameworks like angular and bootstrap.

**Frontend** is where Exercism stores all of it's production client side code.
Exercism doesn't have much JS (outside of bootstrap) but `frontend/` does handle comment threads on submissions, markdown preview on comments, submission code (expanding and contracting), etc. If you suspect that there is frontend wizardry happening and you haven't seen it in bootstrap, most likely it's in here.

#### DB (Migrations)

To create a migration you can use `rake db:generate:migration name=the_name_of_your_migration`.
That will create a new migration in `db/migrate`.
For help, look at the other migrations or at docs for ActiveRecord migrations.
If you add, remove or rename database columns, you may have to update the seeds as well.
Exercism pulls seed data from another repo found [here](https://github.com/exercism/seeds).
The seed data provides placeholder information (like users, exercise submissions, comments, etc) to help with development.

#### Lib (DB Configurations, Application Logic, Models, Rake Tasks)

**Application Logic** can be anything that is used for the backend application (and, possibly, shared with the frontend as well) can live here.
Maybe a library for GitHub OAuth, configurations for a Markdown parser and a syntax highlighter, etc.

**Models** are for connecting classes (e.g. `User`) and their attributes to database tables with ActiveRecord (ones that you set up with migrations), relating them to other tables (e.g. `User` `has_many :posts`) and adding other type functionality (e.g. validations).

#### Test

Tests follow the organization of the app. For instance, if you're writing a new route, it would go in `test/app`. You could write a test post or get and assert that you get back data that you expect. Read more about tests [here](#test-order).

### Additional Directories

#### Bin (Tools)

**Console** provides a REPL (Read-Eval-Print-Loop) with the Exercism application logic pre-loaded.
Want to see what it would look like to be a user that has done every exercise? Console.
Want to test out a new feature but you haven't written the frontend for it? Console.
A bit more info can be found [here](#console).

**Setup** is a script that you can run in order to create the development and test databases, makes sure all the apps dependencies (gems) are installed, etc.

#### Config

Database connection, bugsnag config and local development GitHub OAuth credentials.

#### Docs (Static Files for GitHub Docs)

Static files and pictures for hosting in the GitHub docs.

#### Public (Static Files for the Site)

Static files for the Exercism web app. Fonts, jQuery (`public/js/app.js`), icons, language images, and sass (styling).

#### X

X is a collection of scripts to organize and compile documentation for the many parts of exercism (cli, general help, product introduction, track info).

## Future Roadmap

The focus of the development efforts at the moment are about making the core
experience good: smooth onboarding, rich conversations, high quality feedback,
and getting feedback quickly.

Sometimes we get suggestions for things that would be great, but they're not
part of locking down the core behavior of the app. In this case we'll close
and label it ["future roadmap"](https://github.com/exercism/exercism.io/labels/future%20roadmap)
to make it easy to search for later.

For more resources see:

* [Git Workflow](https://github.com/exercism/x-common/blob/master/CONTRIBUTING.md#git-basics) in the language track contributor guide
* [How to Squash Commits in a GitHub Pull Request](http://blog.steveklabnik.com/posts/2012-11-08-how-to-squash-commits-in-a-github-pull-request)
