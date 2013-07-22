# exercism.io

Application to support working through sequential programming problems, with
crowd-sourced code reviews.

Supports two types of users
- admin/nitpicker
- practitioner

Supports multiple tracks, e.g.
- ruby
- javascript
- go

A practitioner starts a trail, and is given the first assignment, then follows several rounds of code review until an instructor accepts the assignment.

Both nitpickers and practitioners who have successfully completed an assignment can provide code reviews / feedback / comments on an assignment.

## The Data

We are currently working on assignments in:

* ruby
* javascript
* coffeescript
* clojure
* elixir

Only ruby currently has been approached systematically.

The warmup exercises are collected from all over the web.

The common data for assignments are in

```bash
assignments/shared
```

This includes some metadata that gets sewn into a README, as well as a blurb that can be shown on the website.

Not all assignments will be appropriate for all languages.

The actual assignment consists of

* a test suite, where all test are `skip`ped except the first one
* a sample solution that passes the test suite

Each language is configured with a test extension and a code extension.

For ruby, both of these are 'rb', so the test suite is named:

```bash
test.rb
```

and the sample solution is called

```bash
example.rb
```

For JavaScript, the test extension is `spec.js`, and the code extension is `js`, giving `test.spec.js` and `example.js`.

The extensions are also used to detect which language a user is submitting an assignment to via the API (they may be on several trails simultaneously).

The languages/trails are configured in `lib/exercism.rb`.

The list of assignments is just a really big array of assignment slugs in the order that they will be assigned.

Different languages/trails do not need to have the same assignments or the same order.

## Setup

1. Install mongodb with: `brew install mongodb` or `apt-get install mongodb`
2. Get it running: follow instructions to load the server at startup. Ensure that server is currently running
3. Install gems with: `bundle`
4. Get a client id/secret from Github at https://github.com/settings/applications/new.
  * Name: whatever
  * URL: http://localhost:4567
  * Callback url: http://localhost:4567/github/callback
6. Run the database seed with `ruby scripts/seed.rb`
7. Start server with: `EXERCISM_GITHUB_CLIENT_ID=xxx EXERCISM_GITHUB_CLIENT_SECRET=xxx rackup -p 4567`
8. Login at http://localhost:4567.
9. Run [MailCatcher](http://mailcatcher.me/) with `mailcatcher`, and open your browser to [localhost:1080](http://localhost:1080).

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

#### Optional steps

Copy the export values from `scripts/boot.sh.example` into your `~/.bash_profile` or `~/.zshrc`
or
Copy bootrunner `cp scripts/boot.sh.example scripts/boot.sh`

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
heroku config:set BUILDPACK_URL=https://github.com/theotherzach/heroku-buildpack-lineman-ruby.git
```
