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
end
