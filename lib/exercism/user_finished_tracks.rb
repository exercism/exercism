require_relative '../../x'
class UserFinishedTracks
  attr_reader :user

  def self.tracks(user)
    new(user).completed_tracks
  end

  def initialize(user)
    @user = user
  end

  # Resource : http://stackoverflow.com/questions/5490952/merge-array-of-hashes-to-get-hash-of-arrays-of-values

  def completed_tracks
    advanced_tracks = {}
    started_tracks.group_by{|e| e["track_id"]}
                  .map{|key, value|
                    advanced_tracks[key] = value.map{|e| e["problem_slug"]
                      }
                    }
    
    @completed_tracks ||= started_tracks.each_with_object([]) do |db_row, arr|
      track = tracks.find { |t| t.id == db_row['track_id'] }
      arr << track if db_row['problem_slug'].to_i >= track.problems.count
      arr
    end
  end

  private

  def started_tracks
    ActiveRecord::Base.connection.execute(completed_count_sql).to_a
  end

  def completed_count_sql
    <<-SQL
    SELECT language AS track_id, slug AS problem_slug
    FROM user_exercises
    WHERE user_id=#{user.id}
    AND (iteration_count > 0 OR skipped_at IS NOT NULL)
    ORDER BY language
    SQL
  end

  def tracks
    @track ||= X::Track.all
  end
end
