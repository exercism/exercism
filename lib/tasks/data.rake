namespace :data do
  namespace :cleanup do
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
      SQL = <<-SQL
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

    desc "migrate deprecated problems"
    task :deprecated_problems do
      require 'bundler'
      Bundler.require
      require_relative '../exercism'
      {
        'point-mutations' => 'hamming'
      }.each do |deprecated, replacement|
        UserExercise.where(slug: deprecated).each do |exercise|
          if UserExercise.where(slug: replacement, user_id: exercise.user_id, language: exercise.language).count > 0
            next
          end

          exercise.slug = replacement
          exercise.save
          exercise.submissions.each do |submission|
            submission.slug = replacement
            submission.save
          end
          ACL.authorize(exercise.user, exercise.problem)
        end
      end
    end
  end
end
