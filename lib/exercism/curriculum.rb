require 'exercism/curriculum/ruby'
require 'exercism/curriculum/javascript'
require 'exercism/curriculum/coffeescript'
require 'exercism/curriculum/elixir'
require 'exercism/curriculum/clojure'
require 'exercism/curriculum/go'
require 'exercism/curriculum/python'
require 'exercism/curriculum/haskell'

class Exercism
  def self.current_curriculum
    return @curriculum if @curriculum

    @curriculum = Curriculum.new('./assignments')
    @curriculum.add RubyCurriculum.new
    @curriculum.add JavascriptCurriculum.new
    @curriculum.add ElixirCurriculum.new
    @curriculum.add ClojureCurriculum.new
    @curriculum.add PythonCurriculum.new
    @curriculum.add HaskellCurriculum.new
    @curriculum
  end

  def self.trails
    @trails ||= current_curriculum.trails.values
  end

  def self.languages
    @languages ||= current_curriculum.trails.keys.sort
  end
end

class Curriculum
  attr_reader :path, :trails, :locales
  def initialize(path)
    @path = path
    @locales = []
    @trails = {}
  end

  def add(curriculum)
    @trails[curriculum.locale.to_sym] = Trail.new(curriculum.locale, curriculum.slugs, path)
    @locales << curriculum.locale
  end

  def in(language)
    trails[language.to_sym]
  end

  def assign(exercise)
    self.in(exercise.language).assign(exercise.slug)
  end

  def available?(language)
    available_languages.include?(language)
  end

  private

  def available_languages
    locales.map(&:language)
  end

end
