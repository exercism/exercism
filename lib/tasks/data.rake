namespace :data do
  namespace :cleanup do
    desc "normalize action names"
    task :notifications do
      require 'active_record'
      require 'db/connection'

      DB::Connection.establish

      sql = <<-SQL
      UPDATE notifications
      SET action=(CASE
        WHEN action='code' THEN 'iteration'
        WHEN action='nitpick' THEN 'comment'
        END
      )
      WHERE action='code' OR action='nitpick'
      SQL
      ActiveRecord::Base.connection.execute(sql)
    end

    desc "fix broken iterations with missing language"
    task :missing_language do
      require 'active_record'
      require 'db/connection'
      require './lib/exercism/submission'
      require './lib/exercism/user_exercise'
      require './lib/exercism/user'
      require './lib/exercism/acl'
      DB::Connection.establish

      Submission.where(language: '').find_each do |submission|
        submission.language = submission.slug
        submission.slug = submission.solution.keys.first[/^[a-z-]*/]

        ex = UserExercise.where(user_id: submission.user_id, language: submission.language, slug: submission.slug).first
        unless ex
          ex = submission.user_exercise
          ex.language = submission.language
          ex.slug = submission.slug
        end

        submission.user_exercise_id = ex.id
        submission.save
        ex.save

        ex.reload.submissions.order('created_at ASC').each_with_index do |s, i|
          s.version = i + 1
          s.save
        end
        ex.iteration_count = ex.submissions.count
        ex.save

        ACL.authorize(submission.user, submission)
      end

      sql = <<-SQL
        DELETE FROM user_exercises WHERE id IN (
          SELECT ex.id
          FROM user_exercises ex
          LEFT JOIN submissions s
          ON s.user_exercise_id=ex.id
          WHERE s.id IS NULL
        )
      SQL
      ActiveRecord::Base.connection.execute(sql)
    end

    desc "fix iteration count"
    task :iteration_counts do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish

      # update the count for all exercises with submissions
      sql = <<-SQL
        UPDATE user_exercises SET iteration_count=t.total
        FROM (
          SELECT COUNT(id) AS total, user_exercise_id FROM submissions GROUP BY user_exercise_id
        ) AS t
        WHERE t.user_exercise_id=user_exercises.id;
      SQL
      ActiveRecord::Base.connection.execute(sql)

      # fix iterations with no submissions
      sql = <<-SQL
        UPDATE user_exercises SET
          iteration_count=0,
          last_activity=NULL,
          last_activity_at=NULL,
          last_iteration_at=NULL
        WHERE id IN (
          SELECT ex.id
          FROM user_exercises ex
          LEFT JOIN submissions s
          ON ex.id=s.user_exercise_id
          WHERE s.id IS NULL
          AND ex.iteration_count > 0
        )
      SQL
      ActiveRecord::Base.connection.execute(sql)
    end

    desc "delete orphan comments"
    task :comments do
      require 'active_record'
      require 'db/connection'

      DB::Connection.establish

      sql = <<-SQL
      DELETE FROM comments WHERE id IN (
        SELECT c.id
        FROM comments c
        LEFT JOIN submissions s ON c.submission_id=s.id
        WHERE s.id IS NULL
      )
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end
  end

  namespace :migrate do
    desc "migrate subscriptions"
    task :subscriptions do
      require 'active_record'
      require 'db/connection'

      DB::Connection.establish

      # CAN ONLY BE USED PRIOR TO EXPOSING SUBSCRIBE/UNSUBSCRIBE IN UI.

      ActiveRecord::Base.connection.execute("truncate table conversation_subscriptions")

      # subscribe solution authors
      sql = <<-SQL
      INSERT INTO conversation_subscriptions
      (user_id, solution_id, created_at, updated_at)
      SELECT
        user_id,
        user_exercise_id,
        MIN(created_at) AS created_at,
        MIN(created_at) AS updated_at
      FROM submissions
      GROUP BY user_id, user_exercise_id
      SQL
      ActiveRecord::Base.connection.execute(sql)

      # subscribe commenters (ignoring solution author so we don't get duplicate keys)
      sql = <<-SQL
      INSERT INTO conversation_subscriptions
      (user_id, solution_id, created_at, updated_at)
      SELECT
        c.user_id,
        s.user_exercise_id,
        MIN(c.created_at) AS created_at,
        MIN(c.created_at) AS updated_at
      FROM comments c
      INNER JOIN submissions s
        ON c.submission_id=s.id
      WHERE c.user_id<>s.user_id
      GROUP BY c.user_id, s.user_exercise_id
      SQL
      ActiveRecord::Base.connection.execute(sql)
    end

    desc "migrate last iteration timestamps"
    task :last_iteration do
      require 'active_record'
      require 'db/connection'

      DB::Connection.establish

      sql = <<-SQL
      UPDATE user_exercises ex SET last_iteration_at=t.ts
      FROM (
        SELECT MAX(created_at) AS ts, user_exercise_id AS id
        FROM submissions
        GROUP BY user_exercise_id
      ) AS t
      WHERE t.id=ex.id
      SQL
      ActiveRecord::Base.connection.execute(sql)
    end

    desc "reset last activity timestamps and descriptions"
    task :last_activity do
      require 'active_record'
      require 'db/connection'
      require './lib/exercism'
      DB::Connection.establish

      # Reset all exercises to have "last activity" be the submission.
      sql = <<-SQL
        UPDATE user_exercises
        SET last_activity='Submitted an iteration', last_activity_at=t.at
        FROM (
          SELECT MAX(created_at) AS at, user_exercise_id
          FROM submissions GROUP BY user_exercise_id
        ) AS t
        WHERE t.user_exercise_id=user_exercises.id
          AND iteration_count>0
      SQL
      ActiveRecord::Base.connection.execute(sql)

      # Override last activity where a comment is more recent.
      SQL = <<-SQL.freeze
        UPDATE user_exercises SET
          last_activity=t2.description,
          last_activity_at=t2.at
        FROM (
          SELECT
            t1.created_at AS at,
            '@' || u.username || ' commented' AS description,
            t1.exercise_id
          FROM users u
          INNER JOIN (
            SELECT c.created_at AS created_at, c.user_id, s.user_exercise_id AS exercise_id
            FROM comments c
            INNER JOIN submissions s
            ON c.submission_id=s.id
          ) AS t1
          ON t1.user_id=u.id
          ORDER BY t1.created_at DESC
          LIMIT 1
        ) AS t2
        WHERE user_exercises.id=t2.exercise_id
          AND user_exercises.iteration_count>0
          AND (
            user_exercises.last_activity_at IS NULL
          OR
            user_exercises.last_activity_at < t2.at
          )
        ;
      SQL
      ActiveRecord::Base.connection.execute(sql)
    end

    desc "migrate acls"
    task :acls do
      require 'active_record'
      require 'db/connection'
      require './lib/exercism/acl'
      require './lib/exercism/named'
      require './lib/exercism/problem'
      require './lib/exercism/submission'
      require './lib/exercism/user'
      DB::Connection.establish

      Submission.find_each do |submission|
        if submission.user.present?
          ACL.authorize(submission.user, submission.problem)
        end
      end
    end

    desc "migrate mentor acls"
    task :mentor_acls do
      require 'active_record'
      require 'db/connection'
      require './lib/exercism/acl'
      require './lib/exercism/named'
      require './lib/exercism/problem'
      require './lib/exercism/submission'
      require './lib/exercism/user'
      DB::Connection.establish

      User.where('track_mentor IS NOT NULL').where("track_mentor != '--- []\n'").find_each do |user|
        Submission.select('DISTINCT language, slug').where(language: user.track_mentor).each do |submission|
          ACL.authorize(user, submission.problem)
        end
      end
    end

    desc "migrate unconfirmed memberships to membership_invites"
    task :migrate_unconfirmed_memberships do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish

      sql = <<-SQL
        INSERT INTO team_membership_invites(team_id, user_id, inviter_id, created_at, updated_at)
        SELECT team_id, user_id, inviter_id, created_at, updated_at
        FROM team_memberships
        WHERE confirmed is FALSE
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
