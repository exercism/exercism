require 'digest/sha1'

class User < ActiveRecord::Base
  serialize :mastery, Array

  has_many :submissions
  has_many :alerts
  has_many :notifications
  has_many :comments
  has_many :exercises, class_name: "UserExercise"
  has_many :lifecycle_events, ->{ order 'created_at ASC' }, class_name: "LifecycleEvent"

  has_many :management_contracts, class_name: "TeamManager"
  has_many :managed_teams, through: :management_contracts, source: :team
  has_many :team_memberships, ->{ where confirmed: true }, class_name: "TeamMembership"
  has_many :teams, through: :team_memberships
  has_many :unconfirmed_team_memberships, ->{ where confirmed: false }, class_name: "TeamMembership"
  has_many :unconfirmed_teams, through: :unconfirmed_team_memberships, source: :team

  before_save do
    self.key ||= Exercism.uuid
    true
  end
  def source_klass
    "#{source_type.downcase.titlecase}Source".constantize
  end

  def reset_key
    self.key = Exercism.uuid
    save
  end

  def self.from_github(id, username, email, avatar_url)
    user = User.where("github_id = ? or username = ?", id, username).first ||
      User.new(github_id: id, email: email)

    user.github_id  = id if !user.github_id
    user.email      = email if !user.email
    user.username   = username
    user.avatar_url = avatar_url.gsub(/\?.+$/, '') if avatar_url && !user.avatar_url
    track_event = user.new_record?
    user.save
    LifecycleEvent.track('joined', user.id) if track_event
    user
  end

  def self.find_or_create_in_usernames(usernames)
    recruits = usernames - find_in_usernames(usernames).map(&:username)
    User.create recruits.reduce([]) { |acc, curr| acc.push username: curr } unless recruits.empty?
    find_in_usernames(usernames)
  end

  def self.find_in_usernames(usernames)
    where(username: usernames)
  end

  def self.find_by_username(username)
    find_by(username: username)
  end

  def onboarding_steps
    @onboarding_steps ||= lifecycle_events.map(&:key)
  end

  def ongoing
    @ongoing ||= active_submissions.order('updated_at DESC')
  end

  def onboarded?
    !!onboarded_at
  end

  def submissions_on(problem)
    submissions.order('id DESC').where(language: problem.track_id, slug: problem.slug)
  end

  def most_recent_submission
    submissions.order("created_at ASC").last
  end

  def guest?
    false
  end

  def working_on?(problem)
    SubmissionStatus.is_user_working_on?(self, problem)
  end

  def nitpicks_trail?(track_id)
    nitpicker_languages.include?(track_id)
  end

  def nitpicker_languages
    unlocked_languages | mastery
  end

  def completed
    @completed ||= items_where "submissions", "state='done'"
  end

  def nitpicker
    @nitpicker ||= items_where "user_exercises", "is_nitpicker='t'"
  end

  def is?(handle)
    username == handle
  end

  def nitpicker_on?(problem)
    mastery.include?(problem.track_id) || unlocked?(problem)
  end

  def unlocked?(problem)
    exercises.where(language: problem.track_id, slug: problem.slug, is_nitpicker: true).count > 0
  end

  def completed?(problem)
    SubmissionStatus.is_user_done_with?(self, problem)
  end

  def locksmith?
    !mastery.empty?
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

  def latest_submission
    @latest_submission ||= submissions.pending.order(created_at: :desc).first
  end

  def latest_submission_on(problem)
    submissions_on(problem).first
  end

  def active_submissions
    submissions.pending
  end

  def unlocked_languages
    @unlocked_languages ||= exercises.where(is_nitpicker: true).pluck('language').uniq
  end

  def completed_submissions_in(track_id)
    submissions.done.where(language: track_id)
  end

  private

  def items_where(table, condition)
    sql = "SELECT language AS track_id, slug FROM #{table} WHERE user_id = %s AND #{condition} ORDER BY created_at ASC" % id.to_s
    User.connection.execute(sql).to_a.each_with_object(Hash.new {|h, k| h[k] = []}) do |result, problems|
      problems[result["track_id"]] << result["slug"]
    end
  end
end
