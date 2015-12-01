module X
  class Problem
    def self.readme(track_id, slug)
      new('track_id' => track_id, 'slug' => slug).readme
    end

    def self.test_files(track_id, slug)
      new('track_id' => track_id, 'slug' => slug).test_files
    end

    METHODS = [
      :track_id, :slug, :name,
      :blurb

    ]
    attr_reader(*METHODS)

    def initialize(attrs={})
      METHODS.each do |name|
        instance_variable_set(:"@#{name}", attrs[name.to_s])
      end
    end

    def to_s
      slug
    end

    def test_files
      data('tests')
    end

    def readme
      data('readme')
    end

    private
    def data(endpoint)
      status, body = X::Xapi.get('tracks', track_id, 'exercises', slug, endpoint)
      [status, JSON.parse(body)]
    end
  end
end
