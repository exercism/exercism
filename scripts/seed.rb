$:.unshift File.expand_path("./../../lib", __FILE__)
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
attempt = Attempt.new(bob, "def bark_along_little_doggie_when_the_moon_is_full_in_the_sky\n  \"woof\"\nend", 'bob.rb').save
Nitpick.new(attempt.submission.id, admin, 'Not enough code.').save
Nitpick.new(attempt.submission.id, admin, 'I like the method name.').save

[alice, bob, admin].each do |user|
  puts
  puts "Created: #{user.username}"
  puts "API Key: #{user.key}"
end