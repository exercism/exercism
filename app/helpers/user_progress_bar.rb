module ExercismWeb
  module Helpers
    module UserProgressBar
      def percent(language_progress)
        exercise_count = language_progress.user_exercises.count
        exercise_count ||= 0 if exercise_count.nil?
        track_count = language_progress.language_track.count.to_f
        return '0' if track_count.nil? || track_count == 0
        (exercise_count / track_count * 100).to_i.to_s
      end

      def progress_ratio(language_progress)
        "#{language_progress.language}: #{language_progress.user_exercises.count}/#{language_progress.language_track.count} (#{percent language_progress}%)"
      end
    end
  end
end
