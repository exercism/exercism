# exercism.io
[![Build Status](https://travis-ci.org/exercism/exercism.io.png?branch=master)](https://travis-ci.org/exercism/exercism.io)
[![Code Climate](https://codeclimate.com/github/exercism/exercism.io.png)](https://codeclimate.com/github/exercism/exercism.io)
[![Gemnasium](https://gemnasium.com/exercism/exercism.io.png)](https://gemnasium.com/exercism/exercism.io)
[![Coverage Status](https://coveralls.io/repos/exercism/exercism.io/badge.png?branch=master)](https://coveralls.io/r/exercism/exercism.io?branch=master)

To get started using exercism.io to practice or provide feedback on other
people's code, check out the [getting
started](http://exercism.io/getting-started) page on the website.

## Contact Us

To report a bug, suggest improvements to exercism.io, or if you're having trouble
installing or using the CLI, please **[open a GitHub
issue](https://github.com/exercism/exercism.io/issues)**.

If you're having trouble writing the code for an exercise on exercism.io, then
your best bet is [StackOverflow](http://stackoverflow.com/) (remember to tag
the question with #exercism). Another option is to submit the code even though
it doesn't pass the tests yet, and then go to your submission page to explain
where you're stuck.

We welcome questions, and will do our best to help you out!

Follow us on [twitter @exercism_io](https://twitter.com/exercism_io).

Jump in and chat with other exercism enthusiasts on the #exercism channel on irc.freenode.net.
It's not a very active channel, but we're a friendly bunch.

For occasional updates, such as new language tracks being launched,
[sign up for the newsletter](https://tinyletter.com/exercism).

Exercism.io was started by Katrina. To get in touch with her, send an email to
[kytrinyx@exercism.io](mailto:kytrinyx@exercism.io).

## Contributions

Exercism.io is free and open source, and many, many people have contributed to
the project by:

* Reporting, reproducing, or fixing bugs
* Triaging issues
* Suggesting, discussing, or implementing features
* Refactoring
* Improving the design of the site
* Adding tests
* Improving documentation
* Improving test suites for the language tracks
* Adding new problems to existing tracks
* Porting problems to new tracks
* Providing feedback on people's code
* Reviewing pull requests
* ... and more

This is a project that started by accident and could never have gotten off the
ground by the efforts of any single person.

**Thank you!**

## Contributing

If you would like to contribute to exercism, then please read the
[CONTRIBUTING.md](https://github.com/exercism/exercism.io/blob/master/CONTRIBUTING.md)
document, which describes the various parts of the system and how they fit together.

We are working to improve this document, and if you find any part of it confusing, or if
you can't figure out how to get started with something, then rest assured it's not you,
it's us! Please open up a new issue to describe what you were hoping to contribute with,
and what you're wondering about, and we'll figure out together how to improve the
documentation.

## Setup

If you'd like to do work on the exercism.io app, then you'll need to have it
running locally.

### Prerequisites

For working on the backend you'll need both Ruby and Postgresql. Front-end development uses node.js

To install Ruby, check out [rvm](https://rvm.io/), [rbenv](https://github.com/sstephenson/rbenv), or [chruby](https://github.com/postmodern/chruby).

Postgresql can be installed with brew on Mac OS X (`brew install postgresql`). If you're on a linux system
that uses apt-get then run `apt-get install postgresql-9.2`.

Install node and npm on Mac OS X using brew (`brew install node`). On other systems see the [node docs](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

### GitHub OAuth

In order to be able to log into your local version of the application, you will
need to set up some keys on GitHub that the app can talk to.

Go to https://github.com/settings/applications/new

You can name it whatever you want. I have _Exercism (Dev)_.

  * URL: http://localhost:4567
  * Callback url: http://localhost:4567/github/callback

Click _Register application_, and you'll see something like this:

![](/exercism/exercism.io/blob/master/docs/oauth-client-secret.png)

Later you will add the **Client ID** and **Client Secret** to a configuration file.

### The Code

If you're unfamiliar with git and GitHub, don't worry. We'll gladly help you out if you get stuck.

First, you need to get ahold of the code, so you have a copy of it locally that you can make changes to.

* [Fork](https://github.com/exercism/exercism.io/fork) this codebase to your own GitHub account.
* Clone your fork, and change directory into the root of the exercism.io project.

### Configuration

If you use a Ruby version manager such as RVM, rbenv or chruby, then copy `.ruby-version.example`
to `.ruby-version`.

* Copy the environment config: `cp config/env .env`
* Edit `.env` to fill in the GitHub client id/secret from earlier.

All the commented out values can be left alone for now.

You don't need to fill in the values for email stuff unless you're going to be
working on the emails specifically.

You don't need to fill in the EXERCISES_API value unless you're going to be
working on the x-api codebase.

### Dependencies

Next, make sure all the application dependencies are installed:

* Install gems with `bundle install`
* Install `mailcatcher` with `gem install mailcatcher`

### Data

Finally, set up the database. This means both creating the underlying database, and migrating so that it
has all the correct tables, as well as running a script to add fake data, so that there are things to click
around and look at while working on the app.

* Run `rake db:setup` to create the postgresql database.
* Run the database migrations with `rake db:migrate`.
* Fetch the seed data with `rake db:seeds:fetch`.
* Run the database seed with `rake db:seed`.

### Run the application

You can start the server with `foreman start` (sometimes you have to say `bundle exec foreman start`).

Then you can log in at [localhost:4567](http://localhost:4567)

You can view the emails sent in [MailCatcher](http://mailcatcher.me/) in your browser at [localhost:1080](http://localhost:1080).

## Frontend development setup

Lineman watches for file changes and compiles them automatically. It is not
required to be running for the server to run, though.

* Install lineman via `sudo npm install -g lineman`
* To run: `cd frontend` and start lineman with `lineman run`

### SCSS

* Start compass with `compass watch`
* to compile `compass compile`

For CSS we are using Sass (with `.scss`). Feel free to use [Bootstrap 3](http://getbootstrap.com/) components and mixins. Or if you want to use even more mixins you can use [Compass](http://compass-style.org/reference/compass/). Structurewise we try to separate components, mixins and layouts. Where layouts should be a single page (using an HTML id as a selector) and components should be reusable partials, which can look different by layout.

You can find the compass config in `lib/app/config.rb`.

### Styleguide

Our styleguide is reachable under [/styleguide](http://exercism.io/styleguide) and built with [KSS](https://github.com/kneath/kss), which enables you to write examples to `*.scss` files

## Sending Emails

If you want to send emails, you will need to fill out the relevant environment variables in `.env` and uncomment the lines so that the variables get exported.

## Console

There's a script in `bin/console` that will load pry with the exercism environment loaded.
This will let you poke around at the objects in the system, such as finding users and changing
things about submissions or comments, making it easier to test specific things.

```ruby
user = User.find_by_username 'whatever'
user.submissions
```

## Testing

1. Create test database with: `createdb -O exercism exercism_test`.
2. Prepare the test environment with `RACK_ENV=test rake db:migrate`.
3. Make sure that `mailcatcher` is running.
4. Run the test suite with `rake` or `rake test`.

To run a single test suite, you can do so with:

```bash
ruby path/to/the_test.rb
```

If it complains about dependencies, then either we forgot to require the correct dependencies (a distinct possibility), or we are dependening on a particular tag of a gem installed directly from github (this happens on occasion).

If there's a git dependency, you can do this:

```bash
bundle exec ruby path/to/the_test.rb
```

For the require, you'll need to figure out what the missing dependency is. Feel free to open an issue on github. It's likely that someone familiar with the codebase will be able to identify the problem immediately.

### Code coverage

To enable code coverage run:

```bash
COVERAGE=1 rake test
```

Browse the results located in `coverage/index.html`

## Deployment

Let Heroku know that Lineman will be building our assets. From the command line:
```
heroku config:set BUILDPACK_URL=https://github.com/testdouble/heroku-buildpack-lineman-ruby.git
```

## License

GNU Affero General Public License

Copyright (C) 2015 Katrina Owen, _@kytrinyx.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

