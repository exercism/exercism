require 'digest/sha1'

class User < ActiveRecord::Base
  serialize :mastery, Array

  has_many :submissions
  has_many :notifications
  has_many :comments
  has_many :five_a_day_counts
  has_many :exercises, class_name: "UserExercise"
  has_many :lifecycle_events, ->{ order 'created_at ASC' }, class_name: "LifecycleEvent"

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

  def can_access?(problem)
    ACL.where(user_id: id, language: problem.track_id, slug: problem.slug).count > 0
  end

  def self.from_github(id, username, email, avatar_url)
    user = User.where(github_id: id).first
    if user.nil?
      # try to match an invitation that has been sent.
      # GitHub ID will only be nil if the user has never logged in.
      user = User.where(username: username, github_id: nil).first
    end
    if user.nil?
      user = User.new(github_id: id, email: email)
    end

    user.github_id  = id
    user.email      = email if !user.email
    user.username   = username
    user.avatar_url = avatar_url.gsub(/\?.+$/, '') if avatar_url && !user.avatar_url
    track_event = user.new_record?
    user.save

    conflict = User.where(username: username).first
    if conflict.present? && conflict.github_id != user.github_id
      conflict.username = ''
      conflict.save
    end
    LifecycleEvent.track('joined', user.id) if track_event
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

  def onboarding_steps
    @onboarding_steps ||= lifecycle_events.map(&:key)
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

  def increment_five_a_day
    if five_a_day_counts.where(day: Date.today).exists?
      five_a_day_counts.where(day: Date.today).first.increment!(:total)
    else
      FiveADayCount.create(user_id: self.id, total: 1, day: Date.today)
    end
  end

  def count_existing_five_a_day_sql
    <<-SQL
      SELECT total
      FROM five_a_day_counts
      WHERE user_id = #{id}
      AND day = '#{Date.today}'
    SQL
  end

  def count_existing_five_a_day
    ActiveRecord::Base.connection.execute(count_existing_five_a_day_sql).field_values("total").first.to_i
  end

  def five_a_day_exercises
    @exercises_list ||= ActiveRecord::Base.connection.execute(five_a_day_exercises_sql).to_a
  end

  def show_five_suggestions?
    if onboarded? && five_available?
      true
    end
  end

def five_available?
  if five_a_day_exercises.count + count_existing_five_a_day == 5
    true
  end
end

  private

  def items_where(table, condition)
    sql = "SELECT language AS track_id, slug FROM #{table} WHERE user_id = %s AND #{condition} ORDER BY created_at ASC" % id.to_s
    User.connection.execute(sql).to_a.each_with_object(Hash.new {|h, k| h[k] = []}) do |result, problems|
      problems[result["track_id"]] << result["slug"]
    end
  end

  def five_a_day_exercises_sql
    <<-SQL
      SELECT * FROM (
        SELECT DISTINCT ON (s.user_id)
          a.user_id AS commenter, s.user_id AS ex_author_id, u.username AS ex_author, s.language, s.slug, s.nit_count, s.key, ue.last_activity_at
          FROM acls a
          INNER JOIN submissions s
            ON s.language = a.language AND s.slug = a.slug
          INNER JOIN user_exercises ue
            ON s.user_exercise_id = ue.id
          INNER JOIN users u
            ON s.user_id = u.id
          INNER JOIN comments c
            ON s.id = c.submission_id
          WHERE a.language = s.language
          AND a.slug = s.slug
          AND a.user_id <> c.user_id
          AND a.user_id <> s.user_id
          AND a.user_id = #{id}
          AND s.slug <> 'hello-world'
          AND ue.last_iteration_at > (NOW()-INTERVAL '30 days')) AS exercises
      ORDER BY nit_count ASC
      LIMIT (5 - #{count_existing_five_a_day});
    SQL
  end
end
