module ExercismWeb
  module Helpers
    module TrackImage
      def track_image(track, size=80)
        image_src = track.image_file? ? "/img/#{track.id}.png" : '/img/e_red.png'
        "<img src=\"#{image_src}\" width=\"#{size}\" height=\"#{size}\">"
      end

      # TODO: use this instead of track_image
      def track_icon(track_id, size=40)
        '<img src="%s" width="%d" height="%d">' % [track_png(track_id), size, size]
      end

      private

      def track_png(track_id)
        img = "/img/%s.png" % track_id
        if File.exist?("./public/%s" % img)
          img
        else
          "/img/e_red.png"
        end
      end
    end
  end
end
