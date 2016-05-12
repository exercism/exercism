class CreateDailies < ActiveRecord::Migration
  # rubocop:disable Metrics/MethodLength
  def up
    connection.execute <<-SQL
      CREATE OR REPLACE VIEW dailies AS
        SELECT
          acls.user_id,
          ue. KEY,
          u.username,
          ue.slug,
          ue. LANGUAGE,
          COALESCE (COUNT(C . ID), 0) AS COUNT,
          ucl.user_exercise_id
        FROM
          acls
        INNER JOIN user_exercises ue ON ue. LANGUAGE = acls. LANGUAGE
        AND ue.slug = acls.slug
        INNER JOIN submissions s ON ue. ID = s.user_exercise_id
        INNER JOIN users u ON u. ID = ue.user_id
        LEFT JOIN comments C ON C .submission_id = s. ID
        LEFT JOIN (
          SELECT
            submissions.user_exercise_id,
            comments.user_id
          FROM
            comments
          INNER JOIN submissions ON submissions. ID = comments.submission_id
          UNION
            SELECT
              submissions.user_exercise_id,
              likes.user_id
            FROM
              likes
            INNER JOIN submissions ON submissions. ID = likes.submission_id
        ) ucl ON ucl.user_id = acls.user_id AND ue. ID = ucl.user_exercise_id
        WHERE
          ue.archived = 'f'
        AND ue.slug <> 'hello-world'
        AND ue.user_id <> acls.user_id
        AND ue.last_iteration_at > (NOW() - INTERVAL '30 days')
        AND ucl.user_exercise_id IS NULL
        GROUP BY
          acls.user_id,
          ue. KEY,
          u.username,
          ue.slug,
          ue. LANGUAGE,
          ucl.user_exercise_id
        ORDER BY
          COALESCE (COUNT(C . ID), 0)
      SQL
  end
  # rubocop:enable Metrics/MethodLength

  def down
    connection.execute "DROP VIEW IF EXISTS dailies;"
  end
end
