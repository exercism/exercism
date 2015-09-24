class FiveADayCount < ActiveRecord::Base
  belongs_to :user
  # has_and_belongs_to_many :user_exercise
  #
  # scope :today, lambda { where(day: Date.today) }

  def five_suggestions_count
    sql = "select total
           from five_a_day_counts
           where user_id = #{user.id}"
    minus_count = ActiveRecord::Base.connection.execute(sql).field_values("total").first
    if minus_count.nil?
      minus_count = 0
    else
      minus_count
    end
  end

  def exercises_list
    @exercises_list ||= ActiveRecord::Base.connection.execute(exercises_list_sql).to_a
  end

private

  def exercises_list_sql
    <<-SQL
      SELECT * FROM (SELECT DISTINCT ON (s.user_id)
          a.user_id AS commenter, s.user_id AS author_id, u.username AS ex_author, s.language, s.slug, s.nit_count, s.key, ue.last_activity_at
          FROM acls a
          INNER JOIN submissions s ON a.user_id <> s.user_id
          INNER JOIN user_exercises ue ON s.user_exercise_id = ue.id
          INNER JOIN users u ON s.user_id = u.id
          INNER JOIN comments c ON s.id = c.submission_id
          WHERE a.language = s.language
          AND a.slug = s.slug
          AND a.user_id <> c.user_id
          AND ue.last_activity_at > (NOW()-interval '30 days')) AS exercises
      ORDER BY nit_count ASC
      LIMIT (5 - #{five_suggestions_count});
    SQL
  end
end
