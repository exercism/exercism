module ExercismWeb
  module Helpers
    module UserProgressBar
      def percent language_progress
        (language_progress.user_exercises.count/language_progress.language_track.count.to_f * 100).to_i.to_s
      end

      def progress_ratio language_progress
        "#{language_progress.language}: #{language_progress.user_exercises.count}/#{language_progress.language_track.count} (#{percent language_progress}%)"
      end
    end
  end
end
