require_relative '../../x'
class UserProgression

  def self.user_progress(user)
    track_complete_exercises = user.exercises.where("language<>''").where('iteration_count > 0').each_with_object({}) do |exe, bag|
      bag[exe.problem.language] ||= LanguageProgress.new exe.problem.language
      bag[exe.problem.language].add_user_exercise exe
    end
    tracks = track_count
    track_complete_exercises.collect do |lang, language_progress|
      language_progress.tap{ |lang_prog| lang_prog.language_track = tracks[lang] }
    end
  end

  class LanguageProgress
    attr_reader :language, :user_exercises, :last_updated
    attr_accessor :language_track

    def initialize language
      @language = language
      @user_exercises = []
      @language_track = []
    end

    def add_user_exercise exe
      if @last_updated.present? && @last_updated > exe.updated_at
        @last_updated = exe.updated_at
      end
      @user_exercises.push exe
    end

  end
  private
  def self.track_count
    Hash[X::Track.all.collect{|t| [t.language, t.problems]}]
  end
end
