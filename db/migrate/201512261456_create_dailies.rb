class CreateDailies < ActiveRecord::Migration

  def up
    connection.execute (<<-SQL
      CREATE OR REPLACE VIEW dailies AS
        SELECT
          acls.user_id,
          ue. KEY,
          u.username,
          ue.slug,
          ue. LANGUAGE,
          COALESCE (COUNT(C . ID), 0) AS COUNT
        FROM
          acls
        INNER JOIN user_exercises ue ON ue. LANGUAGE = acls. LANGUAGE
        AND ue.slug = acls.slug
        INNER JOIN submissions s ON ue. ID = s.user_exercise_id
        INNER JOIN users u ON u. ID = ue.user_id
        LEFT JOIN comments C ON C .submission_id = s. ID
        WHERE
          ue. ID NOT IN (
            SELECT
              submissions.user_exercise_id
            FROM
              comments
            INNER JOIN submissions ON submissions. ID = comments.submission_id
            WHERE
              ue. ID = submissions.user_exercise_id
            AND comments.user_id = acls.user_id
            UNION
              SELECT
                submissions.user_exercise_id
              FROM
                likes
              INNER JOIN submissions ON submissions. ID = likes.submission_id
              WHERE
                ue. ID = submissions.user_exercise_id
              AND likes.user_id = acls.user_id
          )
        AND ue.archived = 'f'
        AND ue.slug <> 'hello-world'
        AND ue.user_id <> acls.user_id
        AND ue.last_iteration_at > (NOW() - INTERVAL '30 days')
        GROUP BY
          acls.user_id,
          ue. KEY,
          u.username,
          ue.slug,
          ue. LANGUAGE
        ORDER BY
          COALESCE (COUNT(C . ID), 0)
      SQL
      )
  end

  def down
    connection.execute "DROP VIEW IF EXISTS dailies;"
  end
end
