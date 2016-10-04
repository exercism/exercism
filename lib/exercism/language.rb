# Allow all exceptions to be reported to Bugsnag

class Language
  def self.of(id)
    by_track_id[id.to_s.downcase]
  rescue Exception => e
    Bugsnag.notify(e, track: id)
    id
  end

  def self.by_track_id
    @by_track_id ||= X::Track.all.each_with_object({}) do |track, languages|
      languages[track.id] = track.language
    end
  end
end
