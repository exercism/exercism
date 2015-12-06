require_relative 'user_track_queries'

class UserTrack
  extend UserTrack::Queries

  class UserProblem
    include Named

    attr_reader :slug, :total, :unread
    def initialize(slug, total, viewed)
      @slug = slug
      @total = total.to_i
      @unread = [total.to_i-viewed.to_i, 0].max
    end
  end

  def self.all_for(user)
    totals = exercise_counts_per_track(user.id)
    views = viewed_counts_per_track(user.id)
    track_ids = (totals.keys + views.keys).uniq
    tracks = track_ids.each_with_object([]) do |track_id, user_tracks|
      total = totals[track_id].to_i
      next if total == 0

      user_tracks << new(track_id, total, views[track_id])
    end
    tracks.sort_by(&:id)
  end

  def self.problems_for(user, track_id)
    totals = problem_counts_in_track(user.id, track_id)
    views = viewed_counts_in_track(user.id, track_id)
    slugs = (totals.keys + views.keys).uniq
    problems = slugs.each_with_object({}) do |slug, user_problems|
      user_problems[slug] = UserProblem.new(slug, totals[slug], views[slug])
    end
    ordered_slugs(track_id).map {|slug| problems[slug] }.compact
  end

  def self.ordered_slugs(track_id)
    LanguageTrack.new(track_id).ordered_exercises
  end

  attr_reader :id, :total, :unread, :name
  def initialize(id, total, viewed)
    @id = id
    @total = total
    @unread = total.to_i-viewed.to_i
    @name = X::Language.of(id)
  end
end
