# exercism.io

[![Build Status](https://travis-ci.org/kytrinyx/exercism.io.png?branch=master)](https://travis-ci.org/kytrinyx/exercism.io) [![Code Climate](https://codeclimate.com/github/kytrinyx/exercism.io.png)](https://codeclimate.com/github/kytrinyx/exercism.io)

Application to support working through sequential programming problems, with
crowd-sourced code reviews.

## WARNING

This an early-stage experiment. In other words: Shield your eyes, children,
the code is bolted on.

We welcome contributions as we work to figure out what this beast is.

Features may be here today, gone tomorrow.

### What we think we know

The discussions are the most important thing in the application. That
and the evolution of the code. It's not about getting code perfect or
right, but using the pieces of code to talk about the little details of
what makes code expressive.

Each code submission seems very ephemeral right now. You submit. You
resubmit, the old submission goes into hiding along with the discussion
about it.

There are excellent discussions, and it would be great to be able to extract
the learning from these discussions, perhaps into blog posts, perhaps into
checklists to help teach nitpicking.

We believe that there's learning in doing the exercises and receiving feedback,
and there's also learning in reading other people's code and providing feedback.

It would be great if there were a way to have meta-discussions about providing
feedback.

The messaging right now is a disaster. The site is confusing, the process is
opaque, and it's hard to figure out where you need to look to figure stuff
out.

## The Data

The warmup exercises are collected from all over the web.

The common data for assignments are in

```bash
assignments/shared
```

This includes some metadata that gets sewn into a README, as well as a blurb
that can be shown on the website.

Not all assignments will be appropriate for all languages.

The actual assignment consists of

* a test suite, where all test are pending except the first one
* a sample solution that passes the test suite

Each language is configured with a test extension and a code extension.

For ruby, both of these are 'rb', so the test suite is named:

```bash
SLUG_test.rb
```

and the sample solution is called

```bash
example.rb
```

The extensions are also used to detect which language a user is submitting an assignment to via the API (they may be on several trails simultaneously).

The languages/trails are configured in `lib/exercism/curriculum/LANGUAGE.rb`.

The list of assignments is just a really big array of assignment slugs in the order that they will be assigned.

Different languages/trails do not need to have the same assignments or the same order.

## Setup

1. Install mongodb with: `brew install mongodb` or `apt-get install mongodb`
2. Get it running: follow instructions to load the server at startup. Ensure that server is currently running
3. Copy `.ruby-version.example` to `.ruby-version` if you use a Ruby version manager such as RVM, rbenv or chruby
4. Install gems with: `bundle`
5. Get a client id/secret from Github at https://github.com/settings/applications/new.
  * Name: whatever
  * URL: http://localhost:4567
  * Callback url: http://localhost:4567/github/callback
7. Run the database seed with `rake db:seed` (if you want LOTS of data: `rake db:seed[1000]` or some other big number).
8. Copy the boot script `scripts/boot.sh.example` to `scripts/boot.sh` and fill in your GitHub details
9. Start the server with `./scripts/boot.sh`
10. Login at http://localhost:4567.
11. Run [MailCatcher](http://mailcatcher.me/) with `mailcatcher`, and open your browser to [localhost:1080](http://localhost:1080).
12. Work through 'Frontend development setup' below and run lineman for correct styling at http://localhost:4567

## Frontend development setup
1. Install node and npm
  * osx: brew install node
  * others see: https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
2. Install lineman via `sudo npm install -g lineman`
3. `cd frontend` and start lineman with `lineman run`
  * note lineman watches for file changes and compiles them automatically, it is not required to be running for the server to run

## Sending Emails

If you want to send actual emails, you will need to export the following environment variables:

* `EMAIL_USERNAME`
* `EMAIL_PASSWORD`
* `EMAIL_DOMAIN`
* `EMAIL_SMTP_ADDRESS`
* `EMAIL_SMTP_PORT`

You can do this in `scripts/boot.sh` for development.

## Console

There's a script in `bin/console` that will load irb with the exercism environment loaded.

## Testing

Run tests with: `rake test`

Make sure that `mailcatcher` is running.

### Code coverage

To enable code coverage run:

    COVERAGE=1 rake test

Browse the results located in `coverage/index.html`

## Deployment

Let Heroku know that Lineman will be building our assets. From the command line:
```
heroku config:set BUILDPACK_URL=https://github.com/testdouble/heroku-buildpack-lineman-ruby.git
```

## Contributing

Thank you for want to contribute! :heart::sparkling_heart::heart:

Fork and clone. Hack hack hack.
Submit a pull request and tell us why your idea is awesome.

For more details, please read the [contributing guide](https://github.com/kytrinyx/exercism.io/blob/master/CONTRIBUTING.md).

## License

GNU Affero General Public License

Copyright (C) 2013 Katrina Owen, _@kytrinyx.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

