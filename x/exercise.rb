module X
  # Essentially a wrapper around the /exercise resource from the exercises API.
  class Exercise
    module TestFiles
      def self.find(track_id, slug)
        _, body = X::Xapi.get('tracks', track_id, 'exercises', slug, 'tests')
        Exercise.new(JSON.parse(body)['exercise'])
      end
    end

    METHODS = [
      :language, :track_id, :name,
      :slug, :readme, :files, :blurb
    ]

    attr_reader(*METHODS)
    def initialize(attrs={})
      METHODS.each do |name|
        instance_variable_set(:"@#{name}", attrs[name.to_s])
      end
    end
  end
end
