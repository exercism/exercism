require 'time'
require 'faker'

require 'seed/attempt'
require 'seed/comment'
require 'seed/exercise'
require 'seed/pod'
require 'seed/trail'
require 'seed/timeline'
require 'seed/user_pool'

module Seed
=begin
  def self.reset
    Mongoid.default_session.collections.each do |coll|
      unless coll.name == 'system.indexes'
        puts "Removing collection: #{coll.name}"
        coll.drop
      end
    end
  end
=end

  def self.generate_default_users
    [admin, daemon].each do |attributes|
      ::User.create attributes
    end
  end

  def self.admin
    {
      username: 'master',
      github_id: 1,
      mastery: Exercism.languages.map(&:to_s)
    }
  end

  def self.daemon
    {
      username: 'exercism-daemon',
      github_id: 0
    }
  end

  def self.generate(size)
    users = []
    pool = UserPool.new(size)
    pool.people.each do |person|
      user = User.create(username: person.name, github_id: person.id)
      users << user
      pod = Seed::Pod.new
      pod.trails.each do |trail|
        trail.exercises.each do |exercise|
          exercise.attempts.each do |attempt|
            submission = ::Submission.create(attempt.by(user))
            user.complete! submission.exercise if attempt.completed?
            attempt.comments.each do |comment|
              ::Comment.create(comment.by(users.sample, on: submission))
            end
          end
        end
      end
    end
  end
end
