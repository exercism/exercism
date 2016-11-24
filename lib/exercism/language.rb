class Language
  def self.of(track_id)
    by_track_id[track_id.to_s.downcase] || track_id.to_s.downcase
  end

  def self.by_track_id
    @by_track_id ||= Trackler.tracks.each_with_object({}) do |track, languages|
      languages[track.id] = track.language
    end
  end
end
