class Submission < ActiveRecord::Base

  serialize :liked_by, Array

  belongs_to :user
  has_many :comments, order: 'created_at ASC'

  has_many :submission_viewers
  has_many :viewers, through: :submission_viewers

  has_many :muted_submissions
  has_many :muted_by, through: :muted_submissions, source: :user

  has_many :likes
  has_many :liked_by, through: :likes, source: :user

  validates_presence_of :user

  before_create do
    self.state          ||= "pending"
    self.nit_count      ||= 0
    self.version        ||= 0
    self.wants_opinions ||= false
    self.is_liked       ||= false
    self.key            ||= (mongoid_id || generate_key)
    true
  end

  scope :pending, where(state: 'pending')

  def self.completed_for(exercise)
    done.where(language: exercise.language, slug: exercise.slug)
  end

  def self.random_completed_for(exercise)
    where(
      state: ['done', 'tweaked'],
      language: exercise.language,
      slug: exercise.slug
    ).order('RANDOM()').limit(1).first
  end

  def self.related(submission)
    order('created_at ASC').
      where(user_id: submission.user.id, language: submission.language, slug: submission.slug)
  end

  def self.nitless
    pending.where(:'nits._id'.exists => false)
  end


  def self.done
    where(state: 'done').order('created_at DESC')
  end

  def self.on(exercise)
    submission = new
    submission.on exercise
    submission.save
    submission
  end

  def self.assignment_completed?(submission)
    related(submission).done.any?
  end

  def self.unmuted_for(user)
    joins("left join (select submission_id from muted_submissions ms where user_id=#{user.id}) as t ON t.submission_id=submissions.id").where('t.submission_id is null')
  end

  def participants
    @participants ||= DeterminesParticipants.determine(user, related_submissions)
  end

  def nits_by_others_count
    nit_count
  end

  def nits_by_others
    comments.select {|nit| nit.user != self.user }
  end

  def nits_by_self_count
    comments.select {|nit| nit.user == self.user }.count
  end

  def discussion_involves_user?
    [nits_by_self_count, nits_by_others_count].min > 0
  end

  def versions_count
    @versions_count ||= Submission.related(self).count
  end

  def related_submissions
    @related_submissions ||= Submission.related(self).to_a
  end

  def no_version_has_nits?
    @no_previous_nits ||= related_submissions.find_index { |v| v.nits_by_others_count > 0 }.nil?
  end

  def some_version_has_nits?
    !no_version_has_nits?
  end

  def this_version_has_nits?
    nits_by_others_count > 0
  end

  def no_nits_yet?
    !this_version_has_nits?
  end

  def older_than?(time)
    self.created_at.utc < (Time.now.utc - time)
  end

  def exercise
    @exercise ||= Exercise.new(language, slug)
  end

  def assignment
    @assignment ||= trail.assign(slug)
  end

  def on(exercise)
    self.language = exercise.language

    self.slug = exercise.slug
  end

  def supersede!
    if pending? || hibernating? || tweaked?
      self.state = 'superseded'
    end
    self.delete if stashed?
    save
  end

  def submitted?
    true
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

  def stashed?
    state == 'stashed'
  end

  def hibernating?
    state == 'hibernating'
  end

  def tweaked?
    state == 'tweaked'
  end

  def superseded?
    state == 'superseded'
  end

  def wants_opinions?
    wants_opinions
  end

  def enable_opinions!
    self.wants_opinions = true
    self.save
  end

  def disable_opinions!
    self.wants_opinions = false
    self.save
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

  def generate_key
    Digest::SHA1.hexdigest(secret)[0..23]
  end

  private

  def secret
    if ENV['SUBMISSION_SECRET']
      "#{ENV['SUBMISSION_SECRET']} #{rand(10**10)}"
    else
      "There is solemn satisfaction in doing the best you can for #{rand(10**10)} billion people."
    end
  end

  # Experiment: Cache the iteration number so that we can display it
  # on the dashboard without pulling down all the related versions
  # of the submission.
  # Preliminary testing in development suggests an 80% improvement.
  before_create do |document|
    self.version = Submission.related(self).count + 1
  end

  def trail
    Exercism.current_curriculum.trails[language]
  end

  class DeterminesParticipants

    attr_reader :participants

    def self.determine(user, submissions)
      determiner = new(user, submissions)
      determiner.determine
      determiner.participants
    end

    def initialize(user, submissions)
      @user = user
      @submissions = submissions
    end

    def determine
      @participants = Set.new
      @participants.add @user
      @submissions.each do |submission|
        add_submission(submission)
      end
    end

    private

    def add_submission(submission)
      submission.comments.each do |comment|
        add_comment(comment)
      end
    end

    def add_comment(comment)
      @participants.add comment.nitpicker
      comment.mentions.each do |mention|
        @participants.add mention
      end
    end
  end
end
