class Submission < ActiveRecord::Base
  serialize :solution, JSON
  belongs_to :user
  belongs_to :user_exercise
  has_many :comments, -> { order(created_at: :asc) }, dependent: :destroy

  # I don't really want the notifications method,
  # just the dependent destroy
  has_many :notifications, dependent: :destroy, foreign_key: 'iteration_id', class_name: 'Notification'

  has_many :likes, dependent: :destroy
  has_many :liked_by, through: :likes, source: :user

  validates_presence_of :user

  before_create do
    self.nit_count      ||= 0
    self.version        ||= 0
    self.is_liked       ||= false
    self.key            ||= Exercism.uuid
    true
  end

  scope :chronologically, -> { order(created_at: :asc) }
  scope :reversed, -> { order(created_at: :desc) }
  scope :not_commented_on_by, lambda { |user|
    where("submissions.id NOT IN (#{Comment.where(user: user).select(:submission_id).to_sql})")
  }
  scope :not_liked_by, lambda { |user|
    where("submissions.id NOT IN (#{Like.where(user: user).select(:submission_id).to_sql})")
  }

  scope :not_submitted_by, ->(user) { where.not(user: user) }

  scope :between, lambda { |upper_bound, lower_bound|
    where(created_at: upper_bound..lower_bound)
  }

  scope :since, lambda { |timestamp|
    where('submissions.created_at > ?', timestamp)
  }

  scope :for_language, lambda { |language|
    where(language: language)
  }

  scope :recent, -> { since(7.days.ago) }

  scope :related, lambda { |submission|
    chronologically
      .where(user_id: submission.user.id, language: submission.track_id, slug: submission.slug)
  }

  def self.on(problem)
    submission = new
    submission.on problem
    submission.save
    submission
  end

  def viewed_by(user)
    View.create(user_id: user.id, exercise_id: user_exercise_id, last_viewed_at: Time.now.utc)
  rescue ActiveRecord::RecordNotUnique
    View.where(user_id: user.id, exercise_id: user_exercise_id).update_all(last_viewed_at: Time.now.utc)
  end

  def name
    @name ||= slug.split('-').map(&:capitalize).join(' ')
  end

  def uuid
    key
  end

  def activity_description
    "Submitted an iteration"
  end

  def track_id
    language
  end

  def problem
    @problem ||= Problem.new(track_id, slug)
  end

  def on(problem)
    self.language = problem.track_id

    self.slug = problem.slug
  end

  def like!(user)
    self.is_liked = true
    liked_by << user unless liked_by.include?(user)
    save
  end

  def unlike!(user)
    likes.where(user_id: user.id).destroy_all
    self.is_liked = liked_by.length > 0
    save
  end

  def liked?
    is_liked
  end

  def prior
    @prior ||= related.where(version: version - 1).first
  end

  def related
    @related ||= Submission.related(self)
  end

  def exercise_uuid_by(user)
    user.exercises.where('iteration_count > 0').for(problem).pluck('key').first || ""
  end

  # Experiment: Cache the iteration number so that we can display it
  # on the dashboard without pulling down all the related versions
  # of the submission.
  # Preliminary testing in development suggests an 80% improvement.
  before_create do |_|
    self.version = Submission.related(self).count + 1
  end
end
