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
  end
end
