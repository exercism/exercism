require 'exercism/curriculum/clojure'
require 'exercism/curriculum/coffeescript'
require 'exercism/curriculum/elixir'
require 'exercism/curriculum/go'
require 'exercism/curriculum/haskell'
require 'exercism/curriculum/javascript'
require 'exercism/curriculum/objective-c'
require 'exercism/curriculum/ocaml'
require 'exercism/curriculum/perl5'
require 'exercism/curriculum/python'
require 'exercism/curriculum/ruby'
require 'exercism/curriculum/scala'

class Exercism
  def self.subjects
    [
      :clojure,
      :coffeescript,
      :elixir,
      :go,
      :haskell,
      :javascript,
      :objective_c,
      :ocaml,
      :perl5,
      :python,
      :ruby,
      :scala,
    ]
  end

  def self.curriculum
    @curriculum ||= begin
      Curriculum.new('./assignments').tap do |curriculum|
        subjects.each do |type|
          curriculum.add "exercism/#{type}_curriculum".classify.constantize.new
        end
      end
    end
  end

  def self.trails
    @trails ||= curriculum.trails.values
  end

  def self.languages
    @languages ||= curriculum.trails.keys.sort
  end

  def self.current
    @current ||= trails.map(&:name).sort
  end

  def self.upcoming
    @upcoming ||= ['Java', 'Rust', 'Erlang', 'PHP', 'Common Lisp'] - current
  end
end

class Curriculum
  attr_reader :path, :trails
  def initialize(path)
    @path = path
    @trails = {}
  end

  def add(curriculum)
    @trails[curriculum.language.downcase.to_sym] = Trail.new(curriculum.language, curriculum.slugs, path)
  end

  def in(language)
    trails[language.to_sym]
  end

  def available?(language)
    languages.include?(language.to_sym)
  end

  def languages
    trails.keys
  end

end
