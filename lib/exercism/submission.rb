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

  def self.pending
    where(state: 'pending').order_by([:at, :desc])
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

  def stashed?
    state == 'stashed'
  end

  private

  def trail
    Exercism.current_curriculum.trails[language]
  end

end
