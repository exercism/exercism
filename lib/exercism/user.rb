require 'digest/sha1'

class User < ActiveRecord::Base
  serialize :mastery, Array
  serialize :current, Hash
  serialize :completed, Hash

  has_many :submissions
  has_many :notifications
  has_many :comments

  has_many :teams_created, class_name: "Team", foreign_key: :creator_id
  has_many :team_memberships, class_name: "TeamMembership"
  has_many :teams, through: :team_memberships

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
    @ongoing ||= submissions.pending
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

  def do!(exercise)
    self.current[exercise.language] = exercise.slug
    save
  end

  def complete!(exercise)
    self.completed[exercise.language] ||= []
    self.completed[exercise.language] << exercise.slug
    self.current.delete(exercise.language)
    save
  end

  def working_on?(candidate)
    active_submissions.where(language: candidate.language, slug: candidate.slug).count > 0
  end

  def nitpicks_trail?(language)
    nitpicker_languages.include?(language)
  end

  def nitpicker_languages
    (worked_in_languages + mastery).uniq
  end

  def nitpickables
    mastered_slugs = self.mastery.map do |language|
      [language, Exercism.current_curriculum.trails[language.to_sym].slugs]
    end
    return Hash[mastered_slugs].merge(self.completed) do |key, a, b|
      (a + b).uniq
    end
  end

  def current_exercises
    current.to_a.map {|cur| Exercise.new(*cur)}
  end

  def is?(handle)
    username == handle
  end

  def nitpicker_on?(exercise)
    mastery.include?(exercise.language) || completed?(exercise)
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

  def stashed_submissions
    self.submissions.select{ |submission| submission.stashed? }
  end

  def stash_list
    self.stashed_submissions.map(&:stash_name)
  end

  def clear_stash(filename)
    self.stashed_submissions.each do |sub|
      sub.delete if sub.stash_name == filename
    end
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

  def worked_in_languages
    submissions.done.pluck('language').uniq
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

