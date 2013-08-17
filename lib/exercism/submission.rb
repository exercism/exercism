class Submission
  include Mongoid::Document

  field :state, type: String, default: 'pending'
  field :l, as: :language, type: String
  field :s, as: :slug, type: String
  field :c, as: :code, type: String
  field :at, type: Time, default: ->{ Time.now.utc }
  field :a_at, as: :approved_at, type: Time
  field :apr, as: :is_approvable, type: Boolean, default: false
  field :apr_by, as: :flagged_by, type: Array, default: []
  field :op, as: :wants_opinions, type: Boolean, default: false
  field :mt_by, as: :muted_by, type: Array, default: []

  belongs_to :approver, class_name: "User", foreign_key: "github_id"
  belongs_to :user
  embeds_many :nits

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

  def participants
    return @participants if @participants

    participants = Set.new
    participants.add user
    nits.each do |nit|
      participants.add nit.nitpicker
    end
    participants.add approver if approver.present?
    @participants = participants
  end

  def nits_by_others_count
    nits.select {|nit| nit.user != self.user }.count
  end

  def nits_by_self_count
    nits.select {|nit| nit.user == self.user }.count
  end

  def discussion_involves_user?
    [nits_by_self_count, nits_by_others_count].min > 0
  end

  def versions_count
    @versions_count ||= related_submissions.count
  end

  def version
    @version ||= related_submissions.index(self) + 1
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
    self.state = 'superseded' if pending?
    save
  end

  def submitted?
    true
  end

  def approvable?
    is_approvable
  end

  def approved?
    state == 'approved'
  end

  def pending?
    state == 'pending'
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

  def mute!(username)
    muted_by << username
    save
  end

  def unmute!(username)
    muted_by.delete(username)
    save
  end

  def unmute_all!
    muted_by.clear
    save
  end

  private

  def trail
    Exercism.current_curriculum.trails[language]
  end

end
