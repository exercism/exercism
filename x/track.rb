module X
  # Essentially a wrapper around the /tracks resource from the exercises API.
  class Track
    def self.all
      _, body = X::Xapi.get('tracks')
      JSON.parse(body)['tracks'].map do |row|
        new(row)
      end
    end

    def self.find(id)
      _, body = X::Xapi.get('tracks', id)
      new(JSON.parse(body)['track'])
    end

    METHODS = [
      :id, :language, :repository,
      :todo, :problems, :docs,
      :active, :implemented
    ]
    attr_reader(*METHODS)

    alias_method :active?, :active
    alias_method :implemented?, :implemented

    def initialize(data)
      METHODS.each do |name|
        instance_variable_set(:"@#{name}", data[name.to_s])
      end
      @problems = data['problems'].map { |row| Problem.new(row) }
      @docs = Docs.new(data['docs'], repository)
    end

    def fetch_cmd(problem=problems.first)
      "exercism fetch #{id} #{problem}"
    end
  end
end
