class Submission
  include Mongoid::Document

  field :state, type: String, default: 'pending'
  field :l, as: :language, type: String
  field :s, as: :slug, type: String
  field :c, as: :code, type: String
  field :at, type: Time, default: ->{ Time.now.utc }
  field :a_at, as: :approved_at, type: Time
  field :lk, as: :is_liked, type: Boolean, default: false
  field :lk_by, as: :liked_by, type: Array, default: []
  field :op, as: :wants_opinions, type: Boolean, default: false
  field :mt_by, as: :muted_by, type: Array, default: []
  field :nc, as: :nit_count, type: Integer, default: 0 # nits by others
  field :v, as: :version, type: Integer, default: 0
  field :st_n, as: :stash_name, type: String

  belongs_to :user
  has_many :comments

  validates_presence_of :user

  def self.pending_for(language, exercise=nil)
    if exercise
      pending.
        and(language: language.downcase).
        and(slug: exercise.downcase)
    else
      pending.
        and(language: language.downcase)
    end
  end

  def self.completed_for(language, slug)
    approved.where(language: language, slug: slug)
  end

  def self.related(submission)
    order_by(at: :asc).
      where(user_id: submission.user.id, language: submission.language, slug: submission.slug)
  end

  def self.nitless
    pending.where(:'nits._id'.exists => false)
  end

  def self.pending
    where(state: 'pending').desc(:at)
  end

  def self.approved
    where(state: 'approved').desc(:at)
  end

  def self.on(exercise)
    submission = new
    submission.on exercise
    submission.save
    submission
  end

  def self.assignment_completed?(submission)
    related(submission).approved.any?
  end

  def participants
    return @participants if @participants

    participants = Set.new
    participants.add user
    related_submissions.each do |submission|
      submission.comments.each do |nit|
        participants.add nit.nitpicker
	nit.mentions.each { |mention| participants.add mention }
      end
    end
    @participants = participants
  end

  def nits_by_others_count
    nc
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
    self.at < (Time.now.utc - time)
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

  def liked?
    is_liked
  end

  def approved?
    state == 'approved'
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
    muted_by.include?(user.username)
  end

  def mute(username)
    muted_by << username
  end

  def mute!(username)
    mute(username)
    save
  end

  def unmute!(user)
    muted_by.delete(user.username)
    save
  end

  def unmute_all!
    muted_by.clear
    save
  end

  private

  # Experiment: Cache the iteration number so that we can display it
  # on the dashboard without pulling down all the related versions
  # of the submission.
  # Preliminary testing in development suggests an 80% improvement.
  before_create do |document|
    document.v = Submission.related(self).count + 1
  end

  def trail
    Exercism.current_curriculum.trails[language]
  end

end
