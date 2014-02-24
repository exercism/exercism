require 'digest/sha1'

class User < ActiveRecord::Base
  serialize :mastery, Array

  has_many :submissions
  has_many :alerts
  has_many :notifications
  has_many :comments
  has_many :exercises, class_name: "UserExercise"

  has_many :management_contracts, class_name: "TeamManager"
  has_many :managed_teams, through: :management_contracts, source: :team
  has_many :team_memberships, ->{ where confirmed: true }, class_name: "TeamMembership"
  has_many :teams, through: :team_memberships
  has_many :unconfirmed_team_memberships, ->{ where confirmed: false }, class_name: "TeamMembership"
  has_many :unconfirmed_teams, through: :unconfirmed_team_memberships, source: :team

  before_create do
    self.key = create_key
    true
  end

  def self.from_github(id, username, email, avatar_url)
    user = User.where(github_id: id).first ||
           User.new(github_id: id, email: email)

    user.username   = username
    user.avatar_url = avatar_url.gsub(/\?.+$/, '') if avatar_url && !user.avatar_url
    user.save
    user
  end

  def self.find_in_usernames(usernames)
    where('LOWER(username) IN (?)', usernames.map(&:downcase))
  end

  def self.find_by_username(username)
    where('LOWER(username) = ?', username.downcase).first
  end

  def ongoing
    @ongoing ||= active_submissions.order('updated_at DESC')
  end

  def submissions_on(exercise)
    submissions.order('id DESC').where(language: exercise.language, slug: exercise.slug)
  end

  def most_recent_submission
    submissions.order("created_at ASC").last
  end

  def guest?
    false
  end

  def working_on?(candidate)
    active_submissions.where(language: candidate.language, slug: candidate.slug).count > 0
  end

  def nitpicks_trail?(language)
    nitpicker_languages.include?(language)
  end

  def nitpicker_languages
    (unlocked_languages + mastery).uniq
  end

  def completed
    @completed ||= begin
      sql = "SELECT language, slug FROM submissions WHERE user_id = %s AND state='done' ORDER BY created_at ASC" % id.to_s
      User.connection.execute(sql).to_a.each_with_object(Hash.new {|h, k| h[k] = []}) do |result, exercises|
        exercises[result["language"]] << result["slug"]
      end
    end
  end

  def nitpicker
    @nitpicker ||= begin
      sql = "SELECT language, slug FROM user_exercises WHERE user_id = %s AND is_nitpicker='t' ORDER BY created_at ASC" % id.to_s
      User.connection.execute(sql).to_a.each_with_object(Hash.new {|h, k| h[k] = []}) do |result, exercises|
        exercises[result["language"]] << result["slug"]
      end
    end
  end

  def is?(handle)
    username == handle
  end

  def nitpicker_on?(exercise)
    mastery.include?(exercise.language) || unlocked?(exercise)
  end

  def unlocked?(candidate)
    exercises.where(language: candidate.language, slug: candidate.slug, is_nitpicker: true).count > 0
  end

  def completed?(candidate)
    submissions.where(language: candidate.language, slug: candidate.slug, state: 'done').count > 0
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

  def latest_submission_on(exercise)
    submissions_on(exercise).first
  end

  def active_submissions
    submissions.pending
  end

  def unlocked_languages
    @unlocked_languages ||= exercises.where(is_nitpicker: true).pluck('language').uniq
  end

  def worked_in_languages
    @worked_in_languages ||= submissions.done.pluck('language').uniq
  end

  def completed_submissions_in(language)
    submissions.done.where(language: language)
  end

  private

  def create_key
    Digest::SHA1.hexdigest(secret)
  end

  def secret
    if ENV['USER_API_KEY']
      "#{ENV['USER_API_KEY']} #{github_id}"
    else
      "There is solemn satisfaction in doing the best you can for #{github_id} billion people."
    end
  end
end

