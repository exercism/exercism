class CreateDailies < ActiveRecord::Migration
  def up
  connection.execute (<<-SQL
      CREATE OR REPLACE VIEW dailies AS
        SELECT
          acls.user_id,
          ue. KEY,
          u.username,
          ue.slug,
          ue.language,
          COALESCE (COUNT(C . ID), 0) AS count
        FROM
          acls
        INNER JOIN user_exercises ue ON ue.language = acls.language AND ue.slug = acls.slug
        INNER JOIN submissions s ON ue.id = s.user_exercise_id
        INNER JOIN users u ON u. ID = ue.user_id
        LEFT JOIN comments C ON C .submission_id = s. ID
        WHERE
          ue. id NOT IN (
            SELECT
              submissions.user_exercise_id
            FROM
              comments
            INNER JOIN submissions on submissions.id = comments.submission_id
            WHERE
              comments.user_id = acls.user_id
            UNION
            SELECT
              submissions.user_exercise_id
            FROM
              likes
            INNER JOIN submissions on submissions.id = likes.submission_id
            WHERE
              likes.user_id = acls.user_id
            )
        AND ue.archived = 'f'
        AND ue.slug <> 'hello-world'
        AND ue.user_id <> acls.user_id
        GROUP BY
          acls.user_id,
          ue. KEY,
          u.username,
          ue.slug,
          ue.language
        ORDER BY COALESCE (COUNT(C . ID), 0)
      SQL
      )
    end

  def down
    connection.execute "DROP VIEW IF EXISTS dailies;"
  end
end
