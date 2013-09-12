module Seed
  class Pod
    attr_reader :size, :trails

    def initialize(trails = Exercism.trails, options = {})
      @size = options.fetch(:size) {  rand(1..3) }
      @trails = trails.shuffle.sample(size).map { |t| Seed::Trail.new(t) }
    end
  end
end
