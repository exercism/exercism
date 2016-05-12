module ExercismWeb
  module Helpers
    module Submission
      # rubocop:disable Metrics/MethodLength
      def sentencify(names)
        case names.size
        when 0
          ""
        when 1
          names.first.to_s
        when 2
          names.join(' and ').to_s
        else
          last = names.pop
          "#{names.join(', ')}, and #{last}"
        end
      end
      # rubocop:enable Metrics/MethodLength

      def these_people_like_it(liked_by)
        return "" if liked_by.empty?

        everyone = liked_by.map { |user| "<a href='/#{user.username}'>@#{user.username}</a>" }
        "#{sentencify(everyone)} think#{everyone.one? ? 's' : ''} this looks great"
      end

      # rubocop:disable Metrics/MethodLength
      def like_submission_button(submission, user)
        return if user.owns?(submission)

        if submission.liked_by.include?(user)
          action = "unlike"
          text = "I didn't mean to like this!"
        else
          action = "like"
          text = "Looks great!"
        end

        %(
        <form accept-charset="UTF-8" action="/submissions/#{submission.key}/#{action}" method="POST" class="submission-like-button">
          <button type="submit" name="#{action}" class="btn"><i class="fa"></i> #{text}</button>
        </form>
        )
      end
      # rubocop:enable Metrics/MethodLength

      def decrement_version(deleted_submission)
        submission_collection = deleted_submission.user_exercise.submissions
        pivot = deleted_submission.version

        Array(submission_collection[pivot...submission_collection.size]).each do |submission|
          submission.version -= 1
          submission.save!
        end
      end
    end
  end
end
