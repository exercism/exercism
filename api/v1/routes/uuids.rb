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

        def unused?
          (track_uuids & payload.uuids).empty?
        end

        def tracks
          Trackler.tracks.reject {|track| track.id == payload.track_id }
        end

        def track_uuids
          tracks.map {|track| track.send(:exercises).map(&:uuid) }.flatten
        end
      end

      post '/uuids' do
        if TrackUUIDs.new(request.body).unused?
          halt 204
        else
          halt 409
        end
      end
    end
  end
end
