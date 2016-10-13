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
                  .map do |key, value|
                    advanced_tracks[key] = value.map{|e| e["problem_slug"]}
                  end
    started_tracks = []
    advanced_tracks.map do |key, value|
                     track = tracks.find { |t| t.id == key }
                     count = 0
                     value.each do |user_exercised_slug|
                       if track.problems.map(&:slug).include?(user_exercised_slug)
                         count = count + 1
                       end
                     end
                     temp = {'track_id' => key, 'completed_count' => count}
                     started_tracks << temp
                    end
    @completed_tracks ||= started_tracks.each_with_object([]) do |db_row, arr|
      track = tracks.find { |t| t.id == db_row['track_id'] }
      arr << track if db_row['completed_count'].to_i >= track.problems.count
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
