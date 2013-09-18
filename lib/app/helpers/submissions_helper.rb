module Sinatra
  module SubmissionsHelper
    def can_mute?(submission, user)
      submission.user != user
    end

    def mute_button_action_for(submission, user)
      action = submission.muted_by?(user) ? 'unmute' : 'mute'
      "/submissions/#{submission.id}/#{action}"
    end

    def view_count_for(submission)
      count = submission.view_count
      "#{count} " + "view".pluralize(count)
    end

    def these_people_like_it(liked_by)
      everyone = liked_by.map {|name| "@#{name}"}
      case everyone.size
        when 0
          ""
        when 1
          "#{everyone.first} thinks this looks great"
        when 2
          "#{everyone.join(' and ')} think this looks great"
        else
          last = everyone.pop
          "#{everyone.join(', ')}, and #{last} think this looks great"
      end
    end

    def like_submission_button(submission, user)
      
      return unless user.nitpicker_on?(submission.exercise) && !user.owns?(submission)

      if submission.liked_by.include?(user.username)
        action = "unlike"
        text = "I didn't mean to like this!"
      else
        action = "like"
        text = "Looks great!"
      end

      %Q{
        <form accept-charset="UTF-8" action="/submissions/#{submission.id}/#{action}" method="POST" class="pull-left" style="display: inline;">
          <button type="submit" name="#{action}" class="btn">#{text}</button>
        </form>
      }.html_safe
    end
  end
end
