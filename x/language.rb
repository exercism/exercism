module X
  class Language
    def self.of(id)
      tracks.fetch(id.to_s) do
        @@tracks[id.to_s] = Track.find(id).language
      end
    end

    def self.tracks
      @@tracks ||= Track.all.each_with_object({}) do |track, hash|
        hash[track.id] = track.language
      end
    end
  end
end
