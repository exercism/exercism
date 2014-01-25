require 'delegate'

module App
  module User
    class Notification < SimpleDelegator
      def path
        [submitter, submission.user_exercise.key].join('/')
      end

      def submitter
        submission.user.username
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
          'code'
        when regarding == 'nitpick' && count == 1
          'comment'
        when regarding == 'nitpick'
          'comment' # want 'comments'
        when regarding == 'like'
          'thumbs-up'
        end
      end
    end
  end
end
