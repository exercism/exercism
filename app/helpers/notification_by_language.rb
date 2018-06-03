module ExercismWeb
  module Helpers
    module NotificationByLanguage
      def notification_by_language(notifications)
        notification_hash = Hash.new { |h,k| h[k] = [] }

        notifications.each do |notification|
          notification_hash[notification.iteration.problem.language] << notification
        end
        notification_hash
      end
    end
  end
end
