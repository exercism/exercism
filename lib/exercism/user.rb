require 'digest/sha1'

class User
  include Mongoid::Document
  include Locksmith
  include ProblemSet

  field :u, as: :username, type: String
  field :email, type: String
  field :img, as: :avatar_url, type: String
  field :cur, as: :current, type: Hash, default: {}
  field :comp, as: :completed, type: Hash, default: {}
  field :g_id, as: :github_id, type: Integer
  field :key, type: String, default: ->{ create_key }
  field :j_at, type: Time, default: ->{ Time.now.utc }
  field :ms, as: :mastery, type: Array, default: []

  has_many :submissions
  has_many :notifications
  has_many :comments

  def self.from_github(id, username, email, avatar_url)
    user = User.where(github_id: id).first
    user ||= User.new(username: username, github_id: id, email: email, avatar_url: avatar_url)
    if avatar_url && !user.avatar_url
      user.avatar_url = avatar_url.gsub(/\?.+$/, '')
    end
    user.username = username
    user.save
    user
  end

  def ongoing
    @ongoing ||= current_exercises.map do |exercise|
      latest_submission_on(exercise) || NullSubmission.new(exercise)
    end
  end

  def done
    @done ||= completed_exercises.map do |lang, exercises|
      exercises.map do |exercise|
        latest_submission_on(exercise) || NullSubmission.new(exercise)
      end
    end.flatten
  end

  def submissions_on(exercise)
    submissions.order_by(at: :desc).where(language: exercise.language, slug: exercise.slug)
  end

  def most_recent_submission
    submissions.order_by(at: :asc).last
  end

  def guest?
    false
  end

  def do!(exercise)
    self.current[exercise.language] = exercise.slug
    save
  end

  def sees?(language)
    doing?(language) || locksmith_in?(language)
  end

  def complete!(exercise, options = {})
    trail = options[:on]
    self.completed[exercise.language] ||= []
    self.completed[exercise.language] << exercise.slug
    self.current[exercise.language] = trail.after(exercise, completed[exercise.language]).slug
    save
  end

  def nitpicks_trail?(language)
    completed.keys.include?(language) || locksmith_in?(language)
  end

  def current_exercises
    current.to_a.map {|cur| Exercise.new(*cur)}
  end

  def ==(other)
    username == other.username && current == other.current
  end

  def is?(handle)
    username == handle
  end

  def may_nitpick?(exercise)
    nitpicker_on?(exercise) || working_on?(exercise)
  end

  def nitpicker_on?(exercise)
    locksmith_in?(exercise.language) || completed?(exercise)
  end

  def nitpicker?
    locksmith? || completed.size > 0
  end

  def new?
    !locksmith? && submissions.count == 0
  end

  def owns?(submission)
    self == submission.user
  end

  private

  def latest_submission_on(exercise)
    submissions_on(exercise).first
  end

  def create_key
    Digest::SHA1.hexdigest(secret)
  end

  def secret
    "There is solemn satisfaction in doing the best you can for #{github_id} billion people."
  end
end

