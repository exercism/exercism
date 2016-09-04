module X
  # Essentially a wrapper around the /exercise resource from the exercises API.
  class Exercise
    METHODS = [
      :language, :track_id, :name,
      :slug, :readme, :files, :blurb
    ].freeze

    attr_reader(*METHODS)
    def initialize(attrs={})
      METHODS.each do |name|
        instance_variable_set(:"@#{name}", attrs[name.to_s])
      end
    end

    def self.exists?(track_id, slug=nil)
      X::Xapi.request(*['tracks', track_id, slug].compact).status != 404
    end
  end
end
