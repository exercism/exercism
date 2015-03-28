namespace :xapi do
  desc "seed database with test data for x-api acceptance tests"
  task :seed do
    require 'bundler'
    Bundler.require
    require 'exercism'

    user = User.find_by_key('abc123') || User.create(github_id: -1, key: 'abc123', username: 'xapi-test-user')
    user.exercises.destroy_all
    user.submissions.destroy_all

    Submission.create(
      user: user,
      language: 'go',
      slug: 'leap',
      solution: {'leap.go' =>'// iteration 1 (superseded)'},
      state: 'superseded',
      created_at: 10.minutes.ago,
    )
    Submission.create(
      user: user,
      language: 'go',
      slug: 'leap',
      solution: {'leap.go' => '// iteration 2 (done)'},
      state: 'done',
      created_at: 5.minutes.ago,
    )
    Submission.create(
      user: user,
      language: 'haskell',
      slug: 'list-ops',
      solution: {'ListOps.hs' =>'// iteration 1 (pending)'},
      state: 'pending',
    )
    Submission.create(
      user: user,
      language: 'haskell',
      slug: 'word-count',
      solution: {'WordCount.hs' => '// iteration 1 (hibernating)'},
      state: 'hibernating',
    )

    Hack::UpdatesUserExercise.new(user.id, 'go', 'leap').update
    Hack::UpdatesUserExercise.new(user.id, 'haskell', 'list-ops').update
    Hack::UpdatesUserExercise.new(user.id, 'haskell', 'word-count').update
  end
end

