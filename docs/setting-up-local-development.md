# Setting up Local Development

This section walks you through getting the exercism.io app running locally.

- [Get the source code](#get-the-source-code)
- [Install the prerequisites](#install-the-prerequisites)
  - [Running exercism.io directly on your computer](#running-exercismio-directly-on-your-computer)
  - [Running exercism.io with Docker](#running-exercismio-with-docker)
- [Initialize exercism.io](#initialize-exercismio)
- [Run exercism.io locally](#run-exercismio-locally)
- [Run the REPL](#run-the-repl)
- [Troubleshoot](#troubleshoot)
- [Configure Your Local Copy of exercism.io](#configure-your-local-copy-of-exercismio)
- [Testing](#testing)
- [Frontend Development Setup](#frontend-development-setup)

----

## Get the source code

Step one is to get a copy of the source for `exercism.io` to which you can make changes.  For this, you need to do some work in GitHub and use git.

If at any time you need help:

* [GitHub guides](https://guides.github.com) do a good job explaining the basics of using GitHub and git;
* our friendly volunteers in [our support chat](https://gitter.im/exercism/support) will do their best to help you.

Get the code:

1. [Fork](https://github.com/exercism/exercism.io/fork) (i.e. [make a linked copy](https://help.github.com/articles/fork-a-repo/)) of this codebase from `exercism/exercism.io` to your own GitHub account.
2. [Clone](https://help.github.com/articles/cloning-a-repository/) that fork to your local computer.

You now have the source code.  Before you fire-up exercism.io, locally, you need a few more pieces of software...

## Install the prerequisites

Exercism.io depends on the following:

- Ruby (see [`Gemfile`](https://github.com/exercism/exercism.io/blob/master/Gemfile#L3) for exact version).
- PostgreSQL (8.4 or later)
- Node.js (0.10 or later)

These instructions present two options:

1. Run exercism.io [directly on your computer](#running-exercisimio-directly-on-your-computer).
2. Run exercism.io [with Docker](#running-exercismio-with-docker).

### Running exercism.io directly on your computer

These instructions assume you're using a package manager for your OS:

- Windows — [Chocolatey](https://chocolatey.org/install)
- Mac OS X — [Homebrew](http://brew.sh)
- Linux — (whichever comes with your distro, we'll refer to `apt-get`)

#### Installing Ruby

(see [`Gemfile`](https://github.com/exercism/exercism.io/blob/master/Gemfile#L3) for exact version of Ruby to install).

- Windows

  ```
  C:> choco install ruby --version X.Y.Z
  ```
- Mac OS X

  ```
  $ brew update
  $ brew install rbenv
  $ rbenv install X.Y.Z
  ```
- Linux

  ```
  $ sudo apt-get update
  $ sudo apt-get install rbenv ruby-build
  $ rbenv install X.Y.Z
  ```

#### Installing PostgreSQL

- Windows:

  ```
  C:> choco install postgresql
  ```
- Mac OS X

  ```
  $ brew update
  $ brew install postgresql
  ```
- Linux

  ```
  $ sudo apt-get update
  $ sudo apt-get install postgresql postgresql-contrib
  ```

#### Installing Node.js (and npm)

- Windows

  ```
  C:> choco install nodejs
  ```
- Mac OS X

  ```
  $ brew install node
  ```
- Linux

  *(see also [installing Node via package manager](https://nodejs.org/en/download/package-manager/).)*
  ```
  $ sudo apt-get install nodejs
  ```
- For other systems, see the [Node.js docs](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

With this, we're ready to configure, build and run exercism.io locally (skip down to [Initialize exercism.io](#initialize-exercismio))...

### Running exercism.io with Docker

As an alternative to installing exercism.io's dependencies on your host OS, you can do so in a Linux container (i.e. Docker).  See [Docker and exercism.io](https://github.com/exercism/exercism.io/tree/master/docker) for more information on this kind of setup.

----

## Initialize exercism.io

At this point, you have a local [copy of the source code](#get-the-source-code) and [installed the prerequisite software](#install-the-prerequisites).

To initialize your local copy of exercism.io, run the setup script:

NOTE: If you are running exercism.io in a Docker container, prepend the command below with `docker-compose run app` (as described in [Docker and exercism.io: Other Tasks](https://github.com/exercism/exercism.io/tree/master/docker#other-tasks)).

If you are using Windows Subsystem for Linux, you may need [additional steps](#windows-subsystem-for-linux)

```
$ bin/setup
```

The script will:

1. configure the environment;
2. create and seed the development and test databases;
3. run the test suite.

## Run exercism.io locally

NOTE: If you are running exercism.io in a Docker container, prepend all commands below with `docker-compose run app` (as described in [Docker and exercism.io: Other Tasks](https://github.com/exercism/exercism.io/tree/master/docker#other-tasks)).

After you have [initialized exercism.io](#initialize-exercismio) successfully, you're ready to fire it up:

1. Start the server:

   ```bash
   $ bundle exec foreman s -p 4567
   ```
2. Launch a browser and navigate to the homepage: http://localhost:4567.
3. Login as a test user using the `assume` dropdown menu on the top right of the page.

## Run the REPL

When exploring our debugging, you may find it useful to have a [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) that loads the exercism environment.  This is accomplished in Ruby environments through [`pry`](http://pryrepl.org/).

After you have [initialized exercism.io](#initialize-exercismio) successfully, you can start the REPL:

```bash
$ bundle exec bin/console
```

From there, you are in a Ruby prompt.  Anything you can do in the app, you can do on the command-line...

```ruby
user = User.find_by_username 'whatever'
user.submissions
```


## Troubleshoot

### Windows Subsystem for Linux

If ```$ bin/setup``` won't run, and gives you an error similar to ``` set: Illegal option -e ```, open bin/Setup in a text editor and try changing the line feed of the file from CRLF to LF.

Any errors you get while installing the gems is likely because of a missing dependency.
To find that dependency, take the path of the mkmf.log that was generated and run
```
$ vim /path/to/file/mkmf.log
```
(Replace /path/to/file with the path of the log file generated.)

The file will likely indicate a missing header (the file indicated looks like "header.h"), look up the header in your search engine and find the package name for the missing header, and install it using:
```
$ sudo apt-get install pkg-name
```
(Replace pkg-name with the name of the package.)

#### Nokogiri
If Nokogiri fails to install with a error stating aclocal-1.13 is missing, run these commands:
```
$ sudo apt-get update
$ sudo apt-get install libxml2-dev libxslt-dev
$ bundle config build.nokogiri --use-system-libraries
```

### Command not found errors

You may have trouble running commands like `rake` or `pry` if your system has a different version of those gems than the Gemfile. In that case, you will need to prepend those commands with `bundle exec` so that bundler will execute that command in the context of the project's gems rather than your system's gems. If you would like to learn more about this topic and how to alias `bundle exec` (if you don't like typing it out each time), see [this article by Thoughtbot](https://robots.thoughtbot.com/but-i-dont-want-to-bundle-exec).

### Database errors

To debug the database setup, do it step-by-step:

* Create the PostgreSQL database and user: `rake db:setup`
* Run the database migrations: `rake db:migrate`
* Fetch the seed data: `rake db:seeds:fetch`
* Seed the database: `rake db:seed`

The setup task will create a PostgreSQL user called exercism with super user permissions.
If you want to avoid this you may create a user manually and add the needed extensions manually as well.

The seed data gives you a bunch of fake user accounts with submissions in multiple languages as well
as fake comments. In development mode there is an "Assume" menu item to the far right of the
nav bar. This will let you easily assume different fake identities to see the site
from their perspective.

Note that if you installed PostgreSQL on OS X with [Postgres.app](http://postgresapp.com/), you'll need to
[configure your `$PATH`](http://postgresapp.com/documentation/cli-tools.html) in order for
the database setup to complete successfully. `bin/setup` relies on PostgreSQL command line tools
and as Postgres.app does not automatically add the application `bin` directory to your `$PATH`,
you'll need to do this manually.

You need to edit the `config/database.yml` file to specify non-default values. If you do, please edit (or create) a `.git/info/exclude` file so that your changes don't get committed. Unfortunately we have to commit the `config/database.yml` file, because heroku no longer creates a default one.

### Changing the default database user

If you have created a user and are having `PG::Connection ...` or `Peer authentication failed for user ...` issues, you can follow these steps (anywhere that it is stated `PGUSER=postgres` replace `postgres` with your specified username that you use for your postgresql databases):

* Create the PostgreSQL database (this will prompt you to input the password): `PGUSER=postgres rake db:create`
* Run the database migrations: `rake db:migrate`
* Fetch the seed data: `rake db:seeds:fetch`
* Seed the database: `rake db:seed`

## Configure Your Local Copy of exercism.io

### Authenticate with GitHub

When you [initialized your local copy of exercism.io](#initialize-exercismio), it created a set of fake users.  You can log in as one of these faked users by selecting the from the dropdown in the header.  This skips the need to do the OAuth flow with GitHub.

However, if you want to work on the login flow, itself, or for some reason want to log in as yourself, then you will need to setup client authentication OAuth with GitHub.

1. Register your development instance of exercism as an application in GitHub.

    Go to https://github.com/settings/applications/new and enter the following:

    * Application name: `Exercism (Dev)` (this can be whatever you want)
    * Homepage URL: `http://localhost:4567`
    * Authorization callback URL: `http://localhost:4567/github/callback`

    Click _Register application_.

2. Configure your copy of exercism.io to use the OAuth client credentials GitHub generated.

    Viewing the details of your registration, find the client credentials:

    ![](/docs/img/oauth-client-secret.png)

    Edit `.env`, copying the `Client ID` and `Client Secret`.
    ```
    export PORT=4567
    export EXERCISM_GITHUB_CLIENT_ID=abc123
    export EXERCISM_GITHUB_CLIENT_SECRET=abcdef123456
    ```


## Data

If you ran `bin/setup` you should be all set.

You can easily reset an existing database to its original state and add the fake data in one step:

* `rake db:reseed`

If you need to set PostgreSQL parameters like the user and/or database name to use during setup, set `PGUSER` and/or `PGDATABASE` environment values respectively. Example: `PGUSER=pgsql PGDATABASE=postgres rake db:reseed`



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
bundle exec ruby path/to/the_test.rb
```

If it complains about dependencies, feel free to [open a GitHub
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
* To use: use **port 8000** instead of 4567 (e.g. http://localhost:8000/).
  Some links redirect back to port 4567, so if JS reloading doesn't work,
  check for this.

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

To setup the seed data locally, run:

    bundle exec rake db:seeds:fetch
    bundle exec rake db:seed

The first command fetches the seed file and places it under the `db/`
folder as `seeds.sql`. Note that if you're deploying the application to
Heroku, `db:seed` task might fail since the database config file won't
contain the necessary details to access the database. To work around the
problem, there's a task `db:heroku_seed` that can be used.


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
