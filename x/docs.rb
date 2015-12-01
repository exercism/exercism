module X
  # Enhances the track-specific documentation, adding
  # defaults where missing and embellishments that encourage
  # people to submit improvements.
  class Docs
    attr_reader :about, :tests, :installation, :learning, :resources
    def initialize(data, repository)
      @data = data
      @repository = repository

      @about = value('about')
      @tests = value('tests')
      @installation = value('installation')
      @resources = value('resources')
      @learning = value('learning')
    end

    private
    attr_reader :repository, :data

    def value(key)
      if data[key].empty?
        File.read("./x/docs/#{key.upcase}.md").gsub('REPO', repository)
      else
        data[key].strip + better(key)
      end
    end

    def better(key)
      File.read('./x/docs/BETTER.md').gsub('REPO', repository).gsub('KEY', key.upcase)
    end
  end

end
