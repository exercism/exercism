module Stream
  def self.ordered_slugs(track_id)
    @ordered_slugs ||= {}
    @ordered_slugs[track_id] ||= Trackler.tracks[track_id].problems.map(&:slug)
  end
end
