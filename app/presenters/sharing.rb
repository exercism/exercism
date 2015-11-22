module ExercismWeb
  module Presenters
    class Sharing
      def twitter_link(submission)
        %{<a href="https://twitter.com/intent/tweet?text=I just submitted the #{submission.track_id} #{submission.slug} exercise at @exercism_io - #NitpickMyCode at http://exercism.io/submissions/#{submission.key}" id='twitter-share' target="_blank">Share with Twitter</a>}
      end
    end
  end
end
