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

  def num_users
    Submission.where("language = ?", "#{language}").distinct.count(:user_id)
  end

  def num_iterations
    Submission.where("language = ?", "#{language}").count
  end

  def avg_comments
    Submission.where("language = ?", "#{language}").average(:nit_count).to_i
  end

  private
    def problems
      all_tracks['tracks'].find do |track|
        track['slug'] == language
      end['problems']
    end

    def all_tracks
      _, body = Xapi.get('tracks')
      JSON.parse body
    end
end
