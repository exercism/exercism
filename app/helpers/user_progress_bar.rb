module ExercismWeb
  module Helpers
    module UserProgressBar
      def percent progress_values
        return "0" if (progress_values[1] || 0).zero?
        (progress_values[0]/progress_values[1].to_f * 100).to_i.to_s
      end

      def progress_ratio track, progress_values
        "#{track}: #{progress_values[0]}/#{progress_values[1]} (#{percent progress_values}%)"
      end
    end
  end
end
