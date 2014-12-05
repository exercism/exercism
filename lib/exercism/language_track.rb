class LanguageTrack
  attr_reader :language
  def initialize(language)
    @language = language
  end

  def ordered_exercises
    problems.map do |problem|
      problem.gsub("#{language}/", '')
    end
  end

  private
    def problems
      all_tracks['tracks'].find do |track|
        track['slug'] == language
      end['problems']
    end

    def all_tracks
      status, body = Xapi.get('tracks')
      JSON.parse body
    end
end
