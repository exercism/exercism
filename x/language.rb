module X
  class Language
    def self.of(id)
      tracks[id.to_s]
    end

    def self.tracks
      @@tracks ||= fetch_tracks.inject({}) do |hash, track|
        hash[track.id] = track.language
        hash
      end
    end

    def self.fetch_tracks
      @@fetched_tracks ||= Track.all
    end
  end
end
