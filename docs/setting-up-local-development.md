# Setting up Local Development

This section walks you through getting the exercism.io app running locally.

## Prerequisites

### To run the application locally

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

### To run the application inside a Vagrant virtual machine

_Skip this step if you are not using Vagrant. The following assumes your Vagrantfile is configured to forward port 3000 to 3030, adjust the port number to suit your environment._

If you are using a different port than 3000 to forward outside of your Vagrant environment you will need to go into `Procfile_Vagrant` and adjust the port number that applies to your needs.

* Copy the Vagrant Procfile example `cp Procfile_Vagrant.example Procfile_Vagrant`
* Start the server with: `foreman s -f Procfile_Vagrant` (the `-f` explicitly states which Procfile to use and we don't want to use the original Procfile in our vagrant environments)
* Sometimes you need to: `bundle exec foreman s -f Procfile_Vagrant`
* Then you can access the local server at [localhost:3030](http://localhost:3030).
* You can log in as a test user using the `assume` dropdown menu on the top right of the page without creating any new user for the app.

_Again this is assuming you are forwarding port 3000 to 3030 in your Vagrantfile, adjust accordingly to your environment_

## The Code

If you're unfamiliar with git and GitHub, don't worry. We'll gladly help you out if you get stuck. GitHub also has some [helpful guides](https://guides.github.com) for getting started.

First, you need to get ahold of the code, so you have a copy of it locally that you can make changes to.

* [Fork](https://github.com/exercism/exercism.io/fork) this codebase to your own GitHub account.
* Clone your fork, and change directory into the root of the exercism.io project.

## Setup

In most cases, it is easiest to run the `bin/setup` script to automatically setup the defaults for the application. Make sure you have PostgreSQL running in the background.

The script will:

* setup the `.ruby-version` file for your Ruby version manager such as RVM, rbenv or chruby
* copy the environment config to `.env`
* run bundler to install the required gems
* create the development database using the credentials in `config/database.yml`
* download and seed the database with a good starting set of data
* create the test database
* run the test suite

### Troubleshooting

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

## Run The Application

* Start the server with: `foreman s -p 4567`
* Sometimes you need to run `bundle exec foreman s -p 4567` instead (see [Troubleshooting](#troubleshooting) above)
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


## Configuration
### GitHub OAuth

Providing you seeded your local database with fake users, then you can use these to "fake login" as
one of them. There will be a dropdown with identities that you can assume in development mode.

If you want to actually work on the login flow, or if you want to log in as yourself, then
you will need keys on GitHub that the app can talk to.

Go to https://github.com/settings/applications/new and enter the following:

* Application name: You can name it whatever you want, e.g. _Exercism (Dev)_.
* Homepage URL: http://localhost:4567
* Authorization callback URL: http://localhost:4567/github/callback

Click _Register application_, and you'll see something like this:

![](/docs/img/oauth-client-secret.png)

Now you can open `.env` and add the **Client ID** and **Client Secret** values.

All the commented out values in `.env` can be left alone for now.

You don't need to fill in the EXERCISES_API value unless you're going to be working on the x-api codebase.

## Data

If you ran `bin/setup` you should be all set.

You can easily reset an existing database to its original state and add the fake data in one step:

* `rake db:reseed`

If you need to set PostgreSQL parameters like the user and/or database name to use during setup, set `PGUSER` and/or `PGDATABASE` environment values respectively. Example: `PGUSER=pgsql PGDATABASE=postgres rake db:reseed`


## Console

There's a script in `bin/console` that will load pry with the exercism environment loaded. You may need to run this file as `bundle exec bin/console` (see [Troubleshooting](#troubleshooting) above).
This will let you poke around at the objects in the system, such as finding users and changing
things about submissions or comments, making it easier to test specific things.

```ruby
user = User.find_by_username 'whatever'
user.submissions
```

## Testing

The test suite is comprised of various checks to ensure everything is working and styled as expected.

Before any tests can be run, create and migrate a test database: `RACK_ENV=test bundle exec rake db:setup db:migrate`

The entire test suite can then be run with `bundle exec rake test:everything` or just `bundle exec rake` since `test:everything` is the default Rake task.

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

### Test Order

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

### Code Coverage

To enable code coverage run:

```bash
COVERAGE=1 rake test
```

Browse the results located in `coverage/index.html`

## Frontend Development Setup

[Lineman](http://linemanjs.com) watches for file changes and compiles them automatically. It is not
required to be running for the server to run though.

* Install Lineman with: `npm install -g lineman`
* To run: `cd frontend` and start Lineman with `lineman run`

Lineman will compile your javascripts when you run `lineman run`, but before
committing your code, make sure everything is compiled using:

```bash
cd frontend && lineman build
```

### SCSS

We use [Compass](http://compass-style.org/) for compiling Sass files.
During development, you can run the compass watcher to keep your compiled CSS files up to date as changes are made.

```bash
bundle exec compass watch
```

Before committing, tell `compass` to compile the stylesheets for production use.

```bash
bundle exec compass compile -e production --force
```

For CSS we are using Sass (with `.scss`). Feel free to use [Bootstrap 3](http://getbootstrap.com) components and mixins. Or if you want to use even more mixins you can use [Compass](http://compass-style.org/reference/compass/). Structure wise we try to separate components, mixins and layouts. Where layouts should be a single page (using an HTML id as a selector) and components should be reusable partials, which can look different by layout.

You can find the Compass configuration in `config.rb` in the project's root directory.

### Styleguide

Our styleguide is under [/styleguide](http://exercism.io/styleguide) and built with [KSS](https://github.com/kneath/kss), which enables you to write examples to `*.scss` files.

## Deployment

Let Heroku know that Lineman will be building our assets. From the command line:
```bash
heroku config:set BUILDPACK_URL=https://github.com/testdouble/heroku-buildpack-lineman-ruby.git
```

### Live deployment

Live deployment of changes is done periodically by @kytrinyx

To see which version is currently live visit http://exercism.io/version

This will return a json string that looks like this:
```json
{"repository":"https://github.com/exercism/exercism.io","contributing":"https://github.com/exercism/exercism.io/blob/master/CONTRIBUTING.md","build_id":"0ad66d9"}
```
The "build_id" is the git id of the revision that is live, which you can find in the list of commits https://github.com/exercism/exercism.io/commits/master . Any commits above that in the list are still waiting to be released.
You can also go directly to the commit by replacing \[build_id\] in: https://github.com/exercism/exercism.io/commit/[build_id] with the hex value from the json above.

Whenever a new version is released a message will appear in the sidebar of: https://gitter.im/exercism/dev  This is done via a Heroku webhook to a Gitter api endpoint. (You probably don't need to know this.)
