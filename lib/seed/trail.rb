module Seed
  class Trail
    attr_reader :size, :language, :slugs

    def initialize(trail, options = {})
      min = [trail.slugs.size, 5].min
      @size = options.fetch(:size) { rand(1..min) }
      @language = trail.language
      @slugs = trail.slugs[0...size]
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
