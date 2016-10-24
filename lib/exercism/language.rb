class Language
  def self.of(track_id)
    track = Trackler.tracks[track_id.to_s.downcase]
    track.exists? ? track.language : track_id
  end

  def self.by_track_id
    @by_track_id ||= Trackler.tracks.each_with_object({}) do |track, languages|
      languages[track.id] = track.language
    end
  end
end
