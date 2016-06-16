module ExercismWeb
  module Helpers
    module TrackImage
      def track_icon(track_id, size=40)
        '<img src="%s" width="%d" height="%d">' % [track_image(track_id), size, size]
      end

      private

      def track_image(track_id)
        ::X::Track.find(track_id).image
      end
    end
  end
end
