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

daemon_data = {
  username: 'exercism-daemon',
  github_id: 0
}
User.create(daemon_data)

master_data = {
  username: 'master',
  github_id: -1,
  email: "master@example.com",
  mastery: ['ruby', 'elixir']
}
master = User.create(master_data)

alice_data = {
  username: 'alice',
  github_id: -4,
  email: "alice@example.com"
}
alice = User.create(alice_data)

users = []

Exercism.current_curriculum.trails.each do |_, trail|
  (1..60).each do |n|
    locale = trail.locale
    language = locale.language
    username = "#{locale.language}#{n}"
    user = User.create(username: username, email: "#{username}_coder@example.com")
    exercise = trail.first
    user.do! exercise
    users << user.reload

    rand(1..5).times do |i|
      exercise = user.current_in(language) || trail.first
      attempt = Attempt.new(user.reload, "class Code\nend", "#{exercise.slug}/code.#{locale.code_extension}").save
      created_on = Date.today - rand(30)
      attempt.submission.at = created_on.to_time - n.to_i * rand(3600)
      submission = attempt.submission
      submission.save
      submission.reload

      if n.even?
        Nitpick.new(submission.id, master, "It is missing `hey` in iteration #{i}.").save
      end
      if rand(2) == 0
        Completion.new(submission).save
        Attempt.new(user.reload, "class Code \nend", "#{exercise.slug}/code.#{locale.code_extension}").save
        Completion.new(submission).save
        Attempt.new(user.reload, "class Code \nend", "#{exercise.slug}/code.#{locale.code_extension}").save
        Completion.new(submission).save
        Attempt.new(user.reload, "class Code \nend", "#{exercise.slug}/code.#{locale.code_extension}").save
      end

      if rand(10) == 0
        submission.is_liked = true
        submission.liked_by ||= []
        submission.liked_by << users.sample.username
      end
      if rand(10) == 0
        submission.wants_opinions = true
      end

      submission.save
    end
    print locale.code_extension, " "
  end

  exercise = trail.first
  alice.do! exercise
end
attempt = Attempt.new(alice.reload, "class Code \nend", "#{alice.current_in('ruby').slug}/code.rb").save
attempt.submission.at = Time.now.utc - 10
attempt.submission.save

Nitpick.new(attempt.submission.id, master, "It is missing `hey`.").save
Notify.everyone(attempt.submission, 'nitpick')
attempt = Attempt.new(alice.reload, "class Code \nend", "#{alice.current_in('ruby').slug}/code.rb").save
Notify.everyone(attempt.previous_submission, 'code', except: alice)
attempt.submission.at = Time.now.utc - 8
attempt.submission.save
Nitpick.new(attempt.submission.id, master, "The formatting is off. Reindent.").save
Notify.everyone(attempt.submission, 'nitpick', except: master)
attempt = Attempt.new(alice.reload, "class Code \nend", "#{alice.current_in('ruby').slug}/code.rb").save
attempt.submission.at = Time.now.utc - 6
attempt.submission.save
Completion.new(attempt.submission).save
alice.reload

attempt = Attempt.new(alice.reload, "class Code \nend", "#{alice.current_in('ruby').slug}/code.rb").save
attempt.submission.at = Time.now.utc - 4
attempt.submission.save
Nitpick.new(attempt.submission.id, master, "Initialize takes an argument").save
Notify.everyone(attempt.submission, 'nitpick', except: master)
attempt = Attempt.new(alice.reload, "class Code \nend", "#{alice.current_in('ruby').slug}/code.rb").save
attempt.submission.at = Time.now.utc - 2
attempt.submission.save
Nitpick.new(attempt.submission.id, master, "`words.words` is so echo-y.").save
Notify.everyone(attempt.submission, 'nitpick', except: master)
attempt = Attempt.new(alice.reload, "class Code \nend", "#{alice.current_in('ruby').slug}/code.rb").save
Completion.new(attempt.submission).save
alice.reload

attempt = Attempt.new(alice.reload, "class Code \nend", "#{alice.current_in('ruby').slug}/code.rb").save
long_comment = "I really like that you thought to check for nil. I also like that you put all of your answers in the same place and I like that you're hiding the implementation details of your if statement behind those methods that end with a question mark. \r\n\r\nI would rather see a .fetch to access your hash so we don't return nil by mistake. Alternatively, you could use a struct or a very small class to store your answers if you want the more concise dot syntax. @answers.fetch(:fine) vs @answers.fine\r\n\r\nLet's explore that nil check. It is currently in the fine? method which suggests that receiving a nil is a natural state of the system. I would rather see that nil check in a guard method at the top of hey rather than buried in fine?. I would also just blow up and raise an exception because if the Bob object receives nil then something has gone wrong. Zooming out even farther, if I were building this as an app I would put that nil check wherever we first got the input so that way the rest of the system doesn't need to check for it. From that perspective we don't even need a nil check in Bob at all.\r\n\r\nSummary: My suggestions are to either .fetch from your hash or create a struct or object instead. I would also not check for nil at all, assuming that it gets handled at the system input. If I did need to check for nil, I would do it at the top of hey and I would throw an error."
Nitpick.new(attempt.submission.id, master, long_comment).save
Notify.everyone(attempt.submission, 'nitpick', except: master)

bob_data = {
  username: 'bob',
  github_id: -2,
  email: "bob@example.com",
  current: {'ruby' => 'bob'},
}
bob = User.create(bob_data)

attempt = Attempt.new(bob, "def bark_along_little_doggie_when_the_moon_is_full_in_the_sky\n  \"woof\"\nend", 'bob/bob.rb').save
Nitpick.new(attempt.submission.id, master, 'Not enough code.').save
Nitpick.new(attempt.submission.id, master, 'I like the method name.').save

[alice, bob, master].each do |user|
  puts
  puts "Created: #{user.username}"
  puts "API Key: #{user.key}"
end
