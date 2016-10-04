require 'trackler'

module ExercismWeb
  module Helpers
    module TrackImage
      def track_icon(track_id, size=40)
        '<img src="/tracks/%s/icon" width="%d" height="%d" alt="">' % [track_id, size, size]
      end
    end
  end
end
