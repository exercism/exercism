module Seed
  class Trail
    attr_reader :size, :language, :slugs

    def initialize(language, options = {})
      @language = language
      @size = options.fetch(:size) { rand(1..5) }
      @slugs = %w(bob anagram leap word-count binary)[0...size]
    end

    def exercises
      @exercises ||= generate_exercises
    end

    private

    def generate_exercises
      exercises = []
      *done, pending = slugs
      done.each do |slug|
        exercises << Seed::Exercise.new(language, slug)
      end
      exercises << Seed::Exercise.new(language, pending, done: false)
    end
  end
end
