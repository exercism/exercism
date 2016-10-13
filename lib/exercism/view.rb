class View < ActiveRecord::Base
  def self.delete_below_watermarks
    sql = <<-SQL
      DELETE FROM views v
      USING user_exercises ex, watermarks w
      WHERE w.user_id=v.user_id
      AND v.exercise_id=ex.id
      AND w.track_id=ex.language
      AND w.slug=ex.slug
      AND v.last_viewed_at <= w.at;
    SQL
    connection.execute(sql)
  end

  # When an exercise has new activity since
  # the last time it was viewed, the record is
  # no longer useful.
  def self.delete_obsolete
    sql = <<-SQL
      DELETE FROM views v
      USING user_exercises ex
      WHERE v.exercise_id=ex.id
      AND v.last_viewed_at < ex.last_activity_at;
    SQL
    connection.execute(sql)
  end
end
