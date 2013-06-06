require 'digest/sha1'

class User
  include Mongoid::Document

  field :u, as: :username, type: String
  field :cur, as: :current, type: Hash, default: {}

  has_many :submissions

  def submissions_on(exercise)
    submissions.where(language: exercise.language, slug: exercise.slug)
  end

  def do!(exercise)
    self.current[exercise.language] = exercise.slug
    save
  end

  def doing?(language)
    current.key?(language)
  end

  def current_exercises
    current.to_a.map {|cur| Exercise.new(*cur)}
  end

  def current_on(language)
    current_exercises.find {|ex| ex.language == language}
  end

  def ==(other)
    username == other.username && current == other.current
  end

end

