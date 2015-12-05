module X
  class Language
    def self.of(id)
      tracks[id.to_s]
    end

    def self.tracks
      @@tracks ||= Track.all.each_with_object({}) do |track, hash|
        hash[track.id] = track.language
      end
    end
  end
end
