class UserExercise < ActiveRecord::Base
  include Named
  has_many :submissions, -> { order 'created_at ASC' }
  has_many :views, foreign_key: 'exercise_id'

  belongs_to :user

  scope :recently_viewed_by, lambda {|user|
    includes(:user)
      .joins(:views)
      .where('views.user_id': user.id)
      .where('views.last_viewed_at > ?', 30.days.ago).order('views.last_viewed_at DESC')
  }
  scope :current, -> { where(archived: false).where.not(iteration_count: 0).order('last_iteration_at DESC') }
  scope :completed, -> { where.not(iteration_count: 0).order('language, id ASC') }
  scope :archived, -> { where(archived: true).where('iteration_count > 0') }
  scope :for, ->(problem) { where(language: problem.track_id, slug: problem.slug) }
  scope :randomized, -> { order('RANDOM()') }
  scope :by_activity, -> { order('last_activity_at DESC') }

  before_create do
    self.key ||= Exercism.uuid
    true
  end

  def track_id
    language
  end

  def update_last_activity(thing)
    if last_activity_at.nil? || (thing.created_at > last_activity_at)
      self.last_activity_at = thing.created_at
      self.last_activity = thing.activity_description
    end
    self
  end

  def viewed_by(user)
    Submission.new(user_id: user.id, user_exercise_id: id).viewed_by(user)
  end

  def archived?
    archived
  end

  def archive!
    update_attributes(archived: true)
  end

  def unarchive!
    update_attributes(archived: false)
  end

  def request_help!
    update_attributes(help_requested: true)
  end

  def cancel_request_for_help!
    update_attributes(help_requested: false)
  end

  def problem
    @problem ||= Problem.new(track_id, slug)
  end

  def comment_count
    @comment_count ||= Hash(ActiveRecord::Base.connection.execute(comment_count_sql).to_a.first)["total"].to_i
  end

  def decrement_iteration_count!
    update_attributes(iteration_count: iteration_count - 1)
  end

  def last_iteration_at
    @last_iteration ||= self[:last_iteration_at] || NilIteration.new
  end

  private

  def comment_count_sql
    <<-SQL
    SELECT COUNT(c.id) AS total
    FROM comments c
    INNER JOIN submissions s
    ON c.submission_id=s.id
    WHERE s.user_exercise_id=#{id}
    SQL
  end

  class NilIteration
    def to_i
      -1
    end

    def strftime(_)
      "N/A"
    end
  end
end
