namespace :xapi do
  desc "seed database with test data for x-api acceptance tests"
  task :seed do
    require 'bundler'
    Bundler.require
    require 'exercism'

    user = User.find_by_key('abc123') || User.create(github_id: -1, key: 'abc123', username: 'xapi-test-user')
    user.exercises.destroy_all
    user.submissions.destroy_all

    Submission.create(user: user, language: 'go', slug: 'leap', code: '// iteration 1 (superseded)', state: 'superseded', filename: 'one.go', created_at: 10.minutes.ago)
    Submission.create(user: user, language: 'go', slug: 'leap', code: '// iteration 2 (done)', state: 'done', filename: 'one.go', created_at: 5.minutes.ago)
    Submission.create(user: user, language: 'ruby', slug: 'anagram', code: '// iteration 1 (pending)', state: 'pending', filename: 'one.rb')
    Submission.create(user: user, language: 'ruby', slug: 'word-count', code: '// iteration 1 (hibernating)', state: 'hibernating', filename: 'two.rb')

    Hack::UpdatesUserExercise.new(user.id, 'go', 'leap').update
    Hack::UpdatesUserExercise.new(user.id, 'ruby', 'anagram').update
    Hack::UpdatesUserExercise.new(user.id, 'ruby', 'word-count').update


    user = User.find_by_key('xyz456') || User.create(github_id: -2, key: 'xyz456', username: 'xapi-fake-user')
    user.exercises.destroy_all
    user.submissions.destroy_all

    Submission.create(user: user, language: 'go', slug: 'no-such-exercise', code: '// iteration 1 (pending)', state: 'pending', filename: 'one.go', created_at: 10.minutes.ago)

    Hack::UpdatesUserExercise.new(user.id, 'go', 'no-such-exercise').update
  end
end

