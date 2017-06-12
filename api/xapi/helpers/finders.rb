module Xapi
  module Helpers
    module Finders
      def find_track(id)
        track = Trackler.tracks[id]
        unless track.exists?
          halt 404, { error: "No track '%s'" % id }.to_json
        end
        track
      end

      def find_track_and_implementation(track_id, slug)
        track = find_track(track_id)
        implementation = track.implementations[slug]
        unless implementation.exists?
          halt 404, {
            error: "No implementation of '%s' in track '%s'" % [slug, track.id],
          }.to_json
        end
        [track, implementation]
      end
    end
  end
end
