module Stream
  def self.ordered_slugs(track_id)
    @ordered_slugs ||= {}
    @ordered_slugs[track_id] ||= X::Track.find(track_id).problems.map(&:slug)
  end
end
