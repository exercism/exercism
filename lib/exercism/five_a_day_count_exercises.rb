class Five
  def initialize
    user_id = user.id
    five_a_day_count = 5
  end

  def exercises_list
    @exercises_list ||= ActiveRecord::Base.connection.execute(exercises_list_sql).to_a
  end

private

  def exercises_list_sql(user_id, five_a_day_count)
    <<-SQL
      SELECT * FROM (SELECT DISTINCT ON (a.user_id)
          n.user_id AS nitpicker, a.user_id AS author, a.language, a.slug, n.is_nitpicker
          FROM user_exercises n
          INNER JOIN user_exercises a
          ON n.language = a.language AND n.slug = a.slug
          INNER JOIN submissions AS s ON a.user_id = s.user_exercise_id
          INNER JOIN comments AS c ON s.id = c.submissions_id
          WHERE a.archived = false
            AND n.is_nitpicker = true
            AND n.user_id = #{user_id}
            AND a.user_id <> #{user_id}
            AND s.nit_count <= 1
            AND c.user_id <>  #{user_id}
            AND a.last_iteration_at > (NOW()-interval '30 days')) AS exercises
      ORDER BY random()
      LIMIT #{five_a_day_count};
    SQL
  end
end
