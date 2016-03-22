module ExercismWeb
  module Helpers
    module TrackImage
      def track_icon(track_id, size=40)
        '<img src="%s" width="%d" height="%d">' % [track_png(track_id), size, size]
      end

      private

      def track_png(track_id)
        img = "/img/tracks/%s.png" % track_id
        if File.exist?("./public/%s" % img)
          img
        else
          "/img/e_red.png"
        end
      end
    end
  end
end
