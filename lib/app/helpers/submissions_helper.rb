module Sinatra
  module SubmissionsHelper
    def can_mute?(submission, user)
      submission.user != user
    end

    def mute_button_action_for(submission, user)
      action = submission.muted_by?(user.username) ? 'unmute' : 'mute'
      "/submissions/#{submission.id}/#{action}"
    end

    def mute_button_for(submission, user)
      if submission.muted_by?(user.username)
        '<button type="submit" class="btn unmute-btn"><i class="icon-microphone"></i></button>'
      else
        '<button type="submit" class="btn mute-btn"><i class="icon-microphone-off"></i></button>'
      end
    end    
  end
end