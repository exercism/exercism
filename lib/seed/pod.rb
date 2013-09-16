module Seed
  class Pod
    attr_reader :size, :trails

    def initialize(trails = Exercism.trails, options = {})
      @size = options.fetch(:size) {  rand(1..3) }
      @trails = trails.shuffle.sample(size).map { |t| Seed::Trail.new(t) }
    end

    def each_attempt
      trail.exercises.each do |exercise|
        exercise.attempts.each do |attempt|
          yield attempt
        end
      end
    end
  end
end
