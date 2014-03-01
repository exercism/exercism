namespace :xapi do
  desc "seed database with test data for x-api acceptance tests"
  task :seed do
    require 'bundler'
    Bundler.require
    require 'exercism'

    user = User.find_by_key('abc123') || User.create(github_id: -1, key: 'abc123', username: 'xapi-test-user')
    UserExercise.create(user: user, language: 'go', slug: 'leap', state: 'pending')
    UserExercise.create(user: user, language: 'ruby', slug: 'anagram', state: 'done')
    UserExercise.create(user: user, language: 'ruby', slug: 'word-count', state: 'pending')
  end
end

