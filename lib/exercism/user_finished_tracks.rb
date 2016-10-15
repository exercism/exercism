require_relative '../../x'
class UserFinishedTracks
  attr_reader :user

  def self.tracks(user)
    new(user).completed_tracks
  end

  def initialize(user)
    @user = user
  end

  def completed_tracks
    @completed_tracks ||= started_tracks.each_with_object([]) do |db_row, arr|
      track = tracks.find { |t| t.id == db_row['track_id'] }
      arr << track if (db_row['completed_problems'] & track.problems).size >= track.problems.count
      arr
    end
  end

  private

  def started_tracks
    ActiveRecord::Base.connection.execute(completed_count_sql).to_a
  end

  def completed_count_sql
    <<-SQL
    SELECT language AS track_id, string_agg(slug, ',') AS completed_problems
    FROM user_exercises
    WHERE user_id=#{user.id}
    AND (iteration_count > 0 OR skipped_at IS NOT NULL)
    GROUP BY language
    SQL
  end

  def tracks
    @track ||= X::Track.all
  end
end
