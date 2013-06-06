require 'digest/sha1'

class User
  include Mongoid::Document

  field :u, as: :username, type: String
  field :cur, as: :current, type: Hash, default: {}

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

  def ==(other)
    username == other.username && current == other.current
  end

end

