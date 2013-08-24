module Sinatra
  module SubmissionsHelper
    def can_mute?(submission, user)
      submission.user != user
    end

    def mute_button_action_for(submission, user)
      action = submission.muted_by?(user) ? 'unmute' : 'mute'
      "/submissions/#{submission.id}/#{action}"
    end
  end
end
