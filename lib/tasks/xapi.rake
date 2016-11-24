namespace :xapi do
  desc "seed database with test data for x-api acceptance tests"
  task seed: [:connection] do
    # User, Submission and UserExercise require Exercism.uuid
    require 'exercism'

    user = User.find_by_key('abc123') || User.create(github_id: -1, key: 'abc123', username: 'xapi-test-user')
    user.exercises.destroy_all
    user.submissions.destroy_all

    s1 = Submission.create(
      user: user,
      language: 'go',
      slug: 'leap',
      solution: { 'leap.go' => '// iteration 1' },
      created_at: 10.minutes.ago
    )
    s2 = Submission.create(
      user: user,
      language: 'go',
      slug: 'leap',
      solution: { 'leap.go' => '// iteration 2' },
      created_at: 5.minutes.ago
    )
    UserExercise.create!(user: user, language: 'go', slug: 'leap', submissions: [s1, s2], archived: true)

    s3 = Submission.create(
      user: user,
      language: 'haskell',
      slug: 'list-ops',
      solution: { 'ListOps.hs' => '// iteration 1' }
    )
    UserExercise.create!(user: user, language: 'haskell', slug: 'list-ops', submissions: [s3])

    s4 = Submission.create(
      user: user,
      language: 'haskell',
      slug: 'word-count',
      solution: { 'WordCount.hs' => '// iteration 1' }
    )
    UserExercise.create!(user: user, language: 'haskell', slug: 'word-count', submissions: [s4])
  end
end
