Problem = Struct.new(:track_id, :slug) do
  include Named

  def to_s
    "Problem: #{slug} (#{language})"
  end

  def language
    @language ||= Language.of(track_id)
  end

  def in?(other_track_id)
    track_id == other_track_id
  end

  def id
    "%s:%s" % [track_id, slug]
  end
end
