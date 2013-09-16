module Seed
  class Generator
    attr_reader :size, :users

    def initialize(size)
      @size = size
      @users = []
    end

    def run
      pool = UserPool.new(size)
      pool.people.each do |person|
        generate(person)
      end
    end

    private

    def generate(person)
      user = User.create(username: person.name, github_id: person.id)
      users << user
      Seed::Pod.new.each_attempt do |attempt|
        submission = ::Submission.create(attempt.by(user))
        user.complete! submission.exercise if attempt.completed?
        attempt.comments.each do |comment|
          ::Comment.create(comment.by(users.sample, on: submission))
        end
      end
    end
  end
end

