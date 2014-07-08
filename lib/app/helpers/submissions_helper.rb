module Sinatra
  module SubmissionsHelper
    def can_mute?(submission, user)
      submission.user != user
    end

    def mute_button_action_for(submission, user)
      action = submission.muted_by?(user) ? 'unmute' : 'mute'
      "/submissions/#{submission.key}/#{action}"
    end

    def view_count_for(submission)
      count = submission.view_count
      "#{count} " + "view".pluralize(count)
    end

    def sentencify(names)
      case names.size
      when 0
        ""
      when 1
        "#{names.first}"
      when 2
        "#{names.join(' and ')}"
      else
        last = names.pop
        "#{names.join(', ')}, and #{last}"
      end
    end

    def these_people_like_it(liked_by)
      return "" if liked_by.empty?

      everyone = liked_by.map {|user| "<a href='/#{user.username}'>@#{user.username}</a>"}
      "#{sentencify(everyone)} thinks this looks great"
    end

    def like_submission_button(submission, user)

      return unless user.nitpicker_on?(submission.exercise) && !user.owns?(submission)

      if submission.liked_by.include?(user)
        action = "unlike"
        text = "I didn't mean to like this!"
      else
        action = "like"
        text = "Looks great!"
      end

      %Q{
        <form accept-charset="UTF-8" action="/submissions/#{submission.key}/#{action}" method="POST" class="pull-left" style="display: inline;">
          <button type="submit" name="#{action}" class="btn">#{text}</button>
        </form>
      }
    end

    def decrement_version(deleted_submission)
      submission_collection = deleted_submission.user_exercise.submissions
      pivot = deleted_submission.version

      Array(submission_collection[pivot...submission_collection.size]).each do |submission|
        submission.version -= 1
        submission.save!
      end
    end

    def delete_related_notifications(selected_submission)
      selected_submission.notifications.each do |notification|
        notification.delete
      end
    end
  end
end
