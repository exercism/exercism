require 'digest/sha1'

class User < ActiveRecord::Base
  serialize :track_mentor, Array

  has_many :submissions
  has_many :notifications
  has_many :comments
  has_many :dailies, -> (user) { limit(Daily::LIMIT - user.daily_count) }
  has_many :daily_counts
  has_many :exercises, class_name: "UserExercise"

  has_many :management_contracts, class_name: "TeamManager"
  has_many :managed_teams, through: :management_contracts, source: :team
  has_many :team_memberships, ->{ where confirmed: true }, class_name: "TeamMembership", dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :inviters, through: :team_memberships, class_name: "User", foreign_key: :inviter_id
  has_many :unconfirmed_team_memberships, ->{ where confirmed: false }, class_name: "TeamMembership", dependent: :destroy
  has_many :unconfirmed_teams, through: :unconfirmed_team_memberships, source: :team

  before_save do
    self.key ||= Exercism.uuid
    true
  end

  def reset_key
    self.key = Exercism.uuid
    save
  end

  def set_share_key
    self.share_key = Exercism.uuid
    save
  end

  def unset_share_key
    self.share_key = nil
    save
  end

  def can_access?(problem)
    ACL.where(user_id: id, language: problem.track_id, slug: problem.slug).count > 0
  end

  def self.from_github(id, username, email, avatar_url, joined_as=nil)
    user = User.where(github_id: id).first
    if user.nil?
      # try to match an invitation that has been sent.
      # GitHub ID will only be nil if the user has never logged in.
      user = User.where(username: username, github_id: nil).first
    end
    if user.nil?
      user = User.new(github_id: id, email: email)
    end

    if user.joined_as.nil? && !!joined_as
      user.joined_as = joined_as
    end

    user.github_id  = id
    user.email      = email if !user.email
    user.username   = username
    user.avatar_url = avatar_url.gsub(/\?.+$/, '') if avatar_url
    track_event = user.new_record?
    user.save

    conflict = User.where(username: username).first
    if conflict.present? && conflict.github_id != user.github_id
      conflict.username = ''
      conflict.save
    end
    user
  end

  def self.find_or_create_in_usernames(usernames)
    members = find_in_usernames(usernames).map(&:username).map(&:downcase)
    usernames.reject {|username| members.include?(username.downcase)}.each do |username|
      User.create(username: username)
    end
    find_in_usernames(usernames)
  end

  def self.find_in_usernames(usernames)
    where(username: usernames)
  end

  def self.find_by_username(username)
    find_by(username: username)
  end

  def sees_exercises?
    ACL.where(user_id: id).count > 0
  end

  def onboarded?
    !!onboarded_at
  end

  def submissions_on(problem)
    submissions.order('id DESC').where(language: problem.track_id, slug: problem.slug)
  end

  def guest?
    false
  end

  def nitpicker
    @nitpicker ||= items_where "user_exercises", "iteration_count > 0"
  end

  def owns?(submission)
    self == submission.user
  end

  def increment_daily_count
    if daily_counts.today
      daily_counts.today.increment!(:total)
    else
      DailyCount.create(user_id: self.id, total: 1, day: Date.today)
    end
  end

  def show_dailies?
    onboarded? && dailies.any?
  end

  def daily_count
    daily_counts.today ? daily_counts.today.total : 0
  end

  def default_language
    ACL.select('DISTINCT language').where(user_id: id).order(:language).map(&:language).first
  end

  def invite_to_track_mentor(language)
    self.track_mentor << language
    save
    update_acls_for_track_mentor(language)
  end

  def public_user_attributes
    {
      username: username,
      avatar_url: avatar_url,
      github_id: github_id
    }
  end

  private

  def items_where(table, condition)
    sql = "SELECT language AS track_id, slug FROM #{table} WHERE user_id = %s AND #{condition} ORDER BY created_at ASC" % id.to_s
    User.connection.execute(sql).to_a.each_with_object(Hash.new {|h, k| h[k] = []}) do |result, problems|
      problems[result["track_id"]] << result["slug"]
    end
  end

  def update_acls_for_track_mentor(language)
    submissions = Submission.select('DISTINCT language, slug').where(language: language)

    submissions.each do |submission|
      ACL.authorize(self, submission.problem)
    end
  end
end
