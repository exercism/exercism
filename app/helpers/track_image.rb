require 'trackler'

module ExercismWeb
  module Helpers
    module TrackImage
      def track_icon(track_id, size=40)
        language = Trackler.tracks[track_id].language
        '<img src="/tracks/%s/icon" width="%d" height="%d" alt="%s" title="%s">' % [track_id, size, size, language, language]
      end
    end
  end
end
