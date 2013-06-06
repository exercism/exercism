class Submission
  include Mongoid::Document

  field :state, type: String, default: 'pending'
  field :l, as: :language, type: String
  field :s, as: :slug, type: String
  field :c, as: :code, type: String
  field :at, type: Time, default: ->{ Time.now.utc }

  belongs_to :user

  def self.on(exercise)
    submission = new
    submission.on exercise
    submission
  end

  def on(exercise)
    self.language = exercise.language
    self.slug = exercise.slug
  end

  def supercede!
    self.state = 'superceded' if pending?
    save
  end

  def pending?
    state == 'pending'
  end

  def exercise
    @exercise ||= Exercise.new(language, slug)
  end

end
