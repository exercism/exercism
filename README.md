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

The warmup exercises are collected from all over the web.

## MVP

* No design.
* Admins are hard-coded.
* Fetch and submit assignments via the API
* Nitpick
* Level up
* Peers can nitpick
* Support multiple simultaneous tracks.

## Later

* Get Design
* Notifications
* Nitpickers can comment on and delete peer comments.

## Maybe

* implement oauth for improved api security
* admin, to make people nitpickers
* public assignment log (opt in) - handle and latest submission on which assignment
* badges
* a track might hold a tree of sets of assignments

## Setup

1. Install mongodb with: `brew install mongodb` then follow instructions to load the server at startup. Ensure that server is running
2. Install gems with: `bundle`
3. Get a client id/secret from Github at https://github.com/settings/applications/new.
  * Name: whatever
  * URL: http://localhost:4567
  * Callback url: http://localhost:4567/github/callback
4. Add yourself to the admin_users method in user.rb
5. Run the seeds with `ruby scripts/seed.rb`
6. Start server with: `EXERCISM_GITHUB_CLIENT_ID=xxx EXERCISM_GITHUB_CLIENT_SECRET=xxx rackup -p 4567`
7. Login at http://localhost:4567.

#### Optional steps

Copy the export values from `scripts/boot.sh.example` into your `~/.bash_profile` or `~/.zshrc`
or
Copy bootrunner `cp scripts/boot.sh.example scripts/boot.sh`

## Testing

Run tests with: `rake test`