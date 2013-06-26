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

admin = User.create(username: 'kytrinyx', github_id: 276834, email: "katrina.owen@gmail.com")

alice_data = {
  username: 'alice',
  github_id: -1,
  email: "alice@example.com",
  current: {'ruby' => 'bob'},
}
alice = User.create(alice_data)

# Bob
attempt = Attempt.new(alice, "class Bob\nend", "bob.rb").save
Nitpick.new(attempt.submission.id, admin, "It is missing `hey`.").save
attempt = Attempt.new(alice, "class Bob\ndef hey\nend\nend", "bob.rb").save
Nitpick.new(attempt.submission.id, admin, "The formatting is off. Reindent.").save
attempt = Attempt.new(alice, "class Bob\n  def\n  hey\n  end\nend", "bob.rb").save
Approval.new(attempt.submission.id, admin, 'very nice').save
alice.reload

# Word Count
attempt = Attempt.new(alice, "class Words\nend", "words.rb").save
Nitpick.new(attempt.submission.id, admin, "Initialize takes an argument").save
attempt = Attempt.new(alice, "class Words\n  def initialize(words)\n  end\nend", "words.rb").save
Nitpick.new(attempt.submission.id, admin, "`words.words` is so echo-y.").save
attempt = Attempt.new(alice, "class Words\n  def initialize(phrase)\n  end\nend", "words.rb").save
Approval.new(attempt.submission.id, admin, 'better').save
alice.reload

attempt = Attempt.new(alice, "class Anagram\nend", "anagram.rb").save

bob_data = {
  username: 'bob',
  github_id: -2,
  email: "bob@example.com",
  current: {'ruby' => 'bob'},
}
bob = User.create(bob_data)

attempt = Attempt.new(bob, "def bark_along_little_doggie_when_the_moon_is_full_in_the_sky\n  \"woof\"\nend", 'bob.rb').save
Nitpick.new(attempt.submission.id, admin, 'Not enough code.').save
Nitpick.new(attempt.submission.id, admin, 'I like the method name.').save

[alice, bob, admin].each do |user|
  puts
  puts "Created: #{user.username}"
  puts "API Key: #{user.key}"
end
