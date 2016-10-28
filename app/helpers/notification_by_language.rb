module ExercismWeb
  module Helpers
    module NotificationByLanguage
      # rubocop:disable Metrics/AbcSize
      def notification_by_language(notifications)
        notification_hash = Hash.new([])
        notifications.each do |notification|
          if notification_hash[notification.iteration.problem.language].empty?
            notification_hash[notification.iteration.problem.language] = [notification]
          else
            notification_hash[notification.iteration.problem.language] << notification
          end
        end
        notification_hash
      end
    end
  end
end
