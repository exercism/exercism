require_relative 'user_track_queries'

class UserTrack
  extend UserTrack::Queries

  def self.all_for(user)
    totals = exercise_counts_per_track(user.id)
    views = viewed_counts_per_track(user.id)
    track_ids = (totals.keys + views.keys).uniq
    tracks = track_ids.each_with_object([]) do |track_id, user_tracks|
      user_tracks << new(track_id, totals[track_id], views[track_id])
    end
    tracks.sort_by(&:id)
  end

  attr_reader :id, :total, :unread, :name
  def initialize(id, total, viewed)
    @id = id
    @total = total
    @unread = total-viewed
    @name = Language.of(id)
  end
end
