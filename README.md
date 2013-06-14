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
  * URL: http://localhost:9292
  * Callback url: http://localhost:9292/github/callback
4. Start server with: `EXERCISM_GITHUB_CLIENT_ID=xxx EXERCISM_GITHUB_CLIENT_SECRET=xxx rackup`
   You can also export these in your .bash_profile:
   export EXERCISM_GITHUB_CLIENT_ID=xxx
   export EXERCISM_GITHUB_CLIENT_SECRET=xxx
   Then you can start the server with just `rackup`.
5. Login at http://localhost:9292.
6. Add yourself to the admin_users method in user.rb

## Seed

Here's a basic seed script that I've used/tweaked per whatever I need:

```ruby
$:.unshift File.expand_path("../lib", __FILE__)
require 'bundler'
Bundler.require
require 'exercism'

def reset
  Mongoid.default_session.collections.each do |coll|
    unless coll.name == 'system.indexes'
      puts "Removing collection: #{coll.name}"
      coll.drop
    end
  end
end

reset

alice_data = {
  username: 'alice',
  github_id: -1,
  email: "alice@example.com",
  current: {'ruby' => 'nucleotide-count'},
  completed: {'ruby' => %w(bob word-count anagram beer-song)}
}
alice = User.create(alice_data)

bob_data = {
  username: 'bob',
  github_id: -2,
  email: "bob@example.com",
  current: {'ruby' => 'bob'},
}
bob = User.create(bob_data)

admin = User.create(username: 'kytrinyx', github_id: 276834, email: "katrina.owen@gmail.com")

attempt = Attempt.new(alice, 'puts "hello world"', 'nucleotide_count.rb').save
attempt = Attempt.new(bob, "def bark\n  \"woof\"\nend", 'bob.rb').save
Nitpick.new(attempt.submission.id, admin, 'Not enough code.').save
Nitpick.new(attempt.submission.id, admin, 'I like the method name.').save

[alice, bob, admin].each do |user|
  puts
  puts "Created: #{user.username}"
  puts "API Key: #{user.key}"
end
```
