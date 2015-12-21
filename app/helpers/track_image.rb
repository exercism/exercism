module ExercismWeb
  module Helpers
    module TrackImage
      def track_image(track, size=80)
        image_src = track.image_file? ? "/img/#{track.id}.png" : '/img/e_red.png'
        "<img src=\"#{image_src}\" width=\"#{size}\" height=\"#{size}\">"
      end
    end
  end
end
