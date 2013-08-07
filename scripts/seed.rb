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



admin_data = {
  username: 'admin',
  github_id: 0,
  email: "admin@example.com",
  is_admin: true
}
admin = User.create(admin_data)

{
  "ruby" => "rb",
  "clojure" => "clj",
  "javascript" => "js",
  "elixir" => "exs",
}.each do |language,exe|
  (1..60).each do |n|
    index = "#{language}#{n}"
    user = User.create(username: index, github_id: index, email: "#{index}_coder@example.com", current: { language => "bob" })
    rand(1..5).times do |i|
      attempt = Attempt.new(user, "class Bob\nend", "bob.#{exe}").save
      attempt.submission.at = Time.now.utc - n.to_i * 3600
      attempt.submission.save
      Nitpick.new(attempt.submission.id, admin, "It is missing `hey` in iteration #{i}.").save if n.even?
    end
    print exe, " "
  end
end

alice_data = {
  username: 'alice',
  github_id: -1,
  email: "alice@example.com",
  current: {'ruby' => 'bob'},
}
alice = User.create(alice_data)

attempt = Attempt.new(alice, "class Bob\nend", "bob.rb").save
attempt.submission.at = Time.now.utc - 10
attempt.submission.save

Nitpick.new(attempt.submission.id, admin, "It is missing `hey`.").save
Notify.everyone(attempt.submission, admin, 'nitpick')
attempt = Attempt.new(alice, "class Bob\ndef hey\nend\nend", "bob.rb").save
attempt.submission.at = Time.now.utc - 8
attempt.submission.save
Nitpick.new(attempt.submission.id, admin, "The formatting is off. Reindent.").save
Notify.everyone(attempt.submission, admin, 'nitpick')
attempt = Attempt.new(alice, "class Bob\n  def  hey\n  end\nend", "bob.rb").save
attempt.submission.at = Time.now.utc - 6
attempt.submission.save
Approval.new(attempt.submission.id, admin, 'very nice').save
alice.reload

attempt = Attempt.new(alice, "class Words\nend", "words.rb").save
attempt.submission.at = Time.now.utc - 4
attempt.submission.save
Nitpick.new(attempt.submission.id, admin, "Initialize takes an argument").save
Notify.everyone(attempt.submission, admin, 'nitpick')
attempt = Attempt.new(alice, "class Words\n  def initialize(words)\n  end\nend", "words.rb").save
attempt.submission.at = Time.now.utc - 2
attempt.submission.save
Nitpick.new(attempt.submission.id, admin, "`words.words` is so echo-y.").save
Notify.everyone(attempt.submission, admin, 'nitpick')
attempt = Attempt.new(alice, "class Words\n  def initialize(phrase)\n  end\nend", "words.rb").save
Approval.new(attempt.submission.id, admin, 'better').save
Notify.everyone(attempt.submission, admin, 'approval')
alice.reload

attempt = Attempt.new(alice, "class Anagram\nend", "anagram.rb").save
long_comment = "I really like that you thought to check for nil. I also like that you put all of your answers in the same place and I like that you're hiding the implementation details of your if statement behind those methods that end with a question mark. \r\n\r\nI would rather see a .fetch to access your hash so we don't return nil by mistake. Alternatively, you could use a struct or a very small class to store your answers if you want the more concise dot syntax. @answers.fetch(:fine) vs @answers.fine\r\n\r\nLet's explore that nil check. It is currently in the fine? method which suggests that receiving a nil is a natural state of the system. I would rather see that nil check in a guard method at the top of hey rather than buried in fine?. I would also just blow up and raise an exception because if the Bob object receives nil then something has gone wrong. Zooming out even farther, if I were building this as an app I would put that nil check wherever we first got the input so that way the rest of the system doesn't need to check for it. From that perspective we don't even need a nil check in Bob at all.\r\n\r\nSummary: My suggestions are to either .fetch from your hash or create a struct or object instead. I would also not check for nil at all, assuming that it gets handled at the system input. If I did need to check for nil, I would do it at the top of hey and I would throw an error."
Nitpick.new(attempt.submission.id, admin, long_comment).save
Notify.everyone(attempt.submission, admin, 'nitpick')

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
