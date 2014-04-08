require 'delegate'

module ExercismIO
  module Presenters
    class Notification < SimpleDelegator
      def path
        [submitter, item.key].join('/')
      end

      def name
        item.name
      end

      def submitter
        item.user.username
      end

      def activity
        case regarding
        when 'code'
          'New iteration'
        when 'like'
          'Liked'
        when 'nitpick'
          'New comment'
        end
      end

      def at
        created_at
      end

      def icon
        case
        when regarding == 'code'
          'iteration'
        when regarding == 'nitpick'
          'nitpick'
        when regarding == 'like'
          'thumbs-up'
        end
      end
    end
  end
end
