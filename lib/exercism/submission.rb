class Submission < ActiveRecord::Base
  serialize :solution, JSON
  belongs_to :user
  belongs_to :user_exercise
  has_many :comments, ->{ order(created_at: :asc) }, dependent: :destroy

  # I don't really want the notifications method,
  # just the dependent destroy
  has_many :notifications, ->{ where(item_type: 'Submission') }, dependent: :destroy, foreign_key: 'item_id', class_name: 'Notification'

  has_many :submission_viewers, dependent: :destroy
  has_many :viewers, through: :submission_viewers

  has_many :muted_submissions, dependent: :destroy
  has_many :muted_by, through: :muted_submissions, source: :user

  has_many :likes, dependent: :destroy
  has_many :liked_by, through: :likes, source: :user

  validates_presence_of :user

  before_create do
    self.state          ||= "pending"
    self.nit_count      ||= 0
    self.version        ||= 0
    self.is_liked       ||= false
    self.key            ||= Exercism.uuid
    true
  end

  delegate :username, to: :user

  scope :done, ->{ SubmissionStatus.done_submissions }
  scope :pending, ->{ where(state: %w(needs_input pending)) }
  scope :hibernating, ->{ where(state: 'hibernating') }
  scope :needs_input, ->{ where(state: 'needs_input') }
  scope :aging, lambda {
    pending.where('nit_count > 0').older_than(3.weeks.ago)
  }
  scope :chronologically, -> { order(created_at: :asc) }
  scope :reversed, -> { order(created_at: :desc) }
  scope :not_commented_on_by, ->(user) {
    where("id NOT IN (#{Comment.where(user: user).select(:submission_id).to_sql})")
  }
  scope :not_liked_by, ->(user) {
    where("id NOT IN (#{Like.where(user: user).select(:submission_id).to_sql})")
  }

  scope :not_submitted_by, ->(user) { where.not(user: user) }

  scope :between, ->(upper_bound, lower_bound) {
    where(created_at: upper_bound..lower_bound)
  }

  scope :older_than, ->(timestamp) {
    where('submissions.created_at < ?', timestamp)
  }

  scope :since, ->(timestamp) {
    where('submissions.created_at > ?', timestamp)
  }

  scope :for_language, ->(language) {
    where(language: language)
  }

  scope :recent, -> { since(7.days.ago) }

  scope :completed_for, -> (problem) {
    SubmissionStatus.submissions_completed_for(problem, relation: self)
  }

  scope :random_completed_for, -> (problem) {
    completed_for(problem).order('RANDOM()').limit(1).first
  }

  scope :related, -> (submission) {
    chronologically
      .where(user_id: submission.user.id, language: submission.track_id, slug: submission.slug)
  }

  scope :unmuted_for, ->(user) {
    where("id NOT IN (#{MutedSubmission.where(user: user).select(:submission_id).to_sql})")
  }

  def test_data
    test_output.split("\n").grep(/failures/).last if test_output.present?
  end

  def self.on(problem)
    submission = new
    submission.on problem
    submission.save
    submission
  end

  def name
    @name ||= slug.split('-').map(&:capitalize).join(' ')
  end

  def discussion_involves_user?
    nit_count < comments.count
  end

  def older_than?(time)
    self.created_at.utc < (Time.now.utc - time)
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

  def supersede!
    self.state   = 'superseded'
    self.done_at = nil
    save
  end

  def like!(user)
    self.is_liked = true
    self.liked_by << user unless liked_by.include?(user)
    mute(user)
    save
  end

  def unlike!(user)
    likes.where(user_id: user.id).destroy_all
    self.is_liked = liked_by.length > 0
    unmute(user)
    save
  end

  def liked?
    is_liked
  end

  def done?
    state == 'done'
  end

  def pending?
    state == 'pending'
  end

  def hibernating?
    state == 'hibernating'
  end

  def superseded?
    state == 'superseded'
  end

  def muted_by?(user)
    muted_submissions.where(user_id: user.id).exists?
  end

  def mute(user)
    muted_by << user
  end

  def mute!(user)
    mute(user)
    save
  end

  def unmute(user)
    muted_submissions.where(user_id: user.id).destroy_all
  end

  def unmute!(user)
    unmute(user)
    save
  end

  def unmute_all!
    muted_by.clear
    save
  end

  def viewed!(user)
    begin
      self.viewers << user unless viewers.include?(user)
    rescue => e
      # Temporarily output this to the logs
      puts "#{e.class}: #{e.message}"
    end
  end

  def view_count
    viewers.count
  end

  def exercise_completed?
    user_exercise.completed?
  end

  def exercise_hibernating?
    user_exercise.hibernating?
  end

  def exercise_pending?
    user_exercise.pending?
  end

  def prior
    @prior ||= related.where(version: version-1).first
  end

  def related
    @related ||= Submission.related(self)
  end

  def commit_id
    solution.values.first
  end

  def git_rep_info
    "#{username}/#{slug}"
  end

  private

  # Experiment: Cache the iteration number so that we can display it
  # on the dashboard without pulling down all the related versions
  # of the submission.
  # Preliminary testing in development suggests an 80% improvement.
  before_create do |document|
    self.version = Submission.related(self).count + 1
  end
end
