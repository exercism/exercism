module ExercismAPI
  module Routes
    class UUIDs < Core
      class TrackUUIDs
        attr_reader :payload
        def initialize(body)
          body.rewind
          @payload = JSON.parse(body.read, object_class: OpenStruct)
          body.rewind
        end

        def conflicting
          track_uuids & payload.uuids
        end

        def unused?
          conflicting.empty?
        end

        def tracks
          Trackler.tracks.reject {|track| track.id == payload.track_id }
        end

        def track_uuids
          tracks.map {|track| track.send(:exercises).map(&:uuid) }.flatten
        end
      end

      post '/uuids' do
        track_uuids = TrackUUIDs.new(request.body)
        if track_uuids.unused?
          halt 204
        else
          halt 409, {"uuids" => track_uuids.conflicting}.to_json
        end
      end
    end
  end
end
