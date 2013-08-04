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

  belongs_to :approver, class_name: "User", foreign_key: "github_id"
  belongs_to :user
  embeds_many :nits

  def self.pending_for_language(language)
    pending.
      and(language: language.downcase)
  end

  def self.related(submission)
    order_by(at: :asc).
      where(user_id: submission.user.id, language: submission.language, slug: submission.slug)
  end

  def self.nitless
    pending.
      or({ :'nits._id'.exists =>  false },
         { :'nits._id' => :user })
  end

  def self.pending
    where(state: 'pending').desc(:at)
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
      participants.merge nit.comments.map(&:commenter)
    end
    @participants = participants
  end

  def argument_count
    nits.map {|nit| nit.comments.count}.inject(0, :+)
  end

  def nits_by_others_count
    nits.select {|nit| nit.user != self.user }.count
  end

  def discussions_involving_user_count
    nits.flat_map {|nit| nit.comments.select { |comment| comment.commenter == self.user } }.count
  end # triggered only when user has participated in a discussion, implicitly a return receipt on the feedback

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
    !this_version_has_nits
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

  private

  def trail
    Exercism.current_curriculum.trails[language]
  end

end
