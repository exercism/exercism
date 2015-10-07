class UserExercise < ActiveRecord::Base
  include Named
  has_many :submissions, ->{ order 'created_at ASC' }
  has_many :views, foreign_key: 'exercise_id'

  # I don't really want the notifications method,
  # just the dependent destroy
  has_many :notifications, ->{ where(item_type: 'UserExercise') }, dependent: :destroy, foreign_key: 'item_id', class_name: 'Notification'

  belongs_to :user

  scope :recently_viewed_by, lambda {|user|
    includes(:user).
      joins(:views).
      where('views.user_id': user.id).
      where('views.last_viewed_at > ?', 30.days.ago).order('views.last_viewed_at DESC')
  }
  scope :current, ->{ where(archived: false).where.not(iteration_count: 0).order('last_activity_at DESC') }
  scope :archived, ->{ where(archived: true).where('iteration_count > 0') }
  scope :for, lambda { |problem| where(language: problem.track_id, slug: problem.slug) }
  scope :randomized, ->{ order('RANDOM()') }
  scope :unsubmitted, ->{ where(archived: false, iteration_count: 0, skipped_at: nil).where.not(fetched_at: nil) }
  scope :by_activity, ->{ order('last_activity_at DESC') }

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

  def nit_count
    submissions.pluck(:nit_count).sum
  end

  def problem
    @problem ||= Problem.new(track_id, slug)
  end

  def comment_count
    @comment_count ||= Hash(ActiveRecord::Base.connection.execute(comment_count_sql).to_a.first)["total"].to_i
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
end
