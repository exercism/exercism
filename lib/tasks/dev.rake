namespace :dev do
  namespace :seed do
    desc "insert a bunch of iterations for the given user"
    task iterations: [:connection] do
      username = ENV['username'] || ENV['USERNAME']
      if username.nil?
        $stderr.puts "Usage: rake dev:seed:iterations username=$USERNAME"
        exit 1
      end

      class FakeTrack < Struct.new(:id, :extension, :slugs, :code)
      end

      go = ["hello-world", "leap", "clock", "gigasecond", "raindrops", "triangle", "difference-of-squares", "secret-handshake", "food-chain", "house", "pascals-triangle", "series", "queen-attack", "grains"]
      ruby = ["hello-world", "hamming", "gigasecond", "rna-transcription", "raindrops", "difference-of-squares", "roman-numerals", "robot-name", "nth-prime", "leap", "grains", "word-count", "bob", "food-chain", "sieve", "binary", "accumulate", "sum-of-multiples", "grade-school"]
      haskell = ["leap", "accumulate", "rna-transcription", "sublist", "grains", "gigasecond", "bob", "sum-of-multiples", "strain", "point-mutations", "space-age", "anagram", "nucleotide-count", "phone-number", "grade-school", "simple-linked-list", "list-ops", "word-count", "etl"]

      tracks = [
        FakeTrack.new("go", "go", go, "// code"),
        FakeTrack.new("ruby", "rb", ruby, "# code"),
        FakeTrack.new("haskell", "hs", haskell, "-- code"),
      ]

      require 'exercism'

      user = User.find_by_username(username)

      tracks.each do |track|
        track.slugs.each do |slug|
          solution = {
            "%s/file.%s" % [slug, track.extension] => track.code,
          }
          Submission.create(user_id: user.id, language: track.id, slug: slug, solution: solution)
          Hack::UpdatesUserExercise.new(user.id, track.id, slug).update
          ACL.authorize(user, Problem.new(track.id, slug))
        end
      end
    end

    desc "create a bunch of notifications"
    task notifications: [:connection] do
      username = ENV['username'] || ENV['USERNAME']
      if username.nil?
        $stderr.puts "Usage: rake dev:seed:notifications username=$USERNAME"
        exit 1
      end
      require 'exercism/notification'
      require 'exercism/user'
      require 'exercism/submission'

      user = User.find_by_username(username)
      actor_id = User.where("username <> '%s'" % user.username).limit(100).pluck(:id).sample.to_i
      user.submissions.shuffle.each do |submission|
        Notification.on(submission, user_id: user.id, action: 'comment', actor_id: actor_id)
      end
    end
  end
end
