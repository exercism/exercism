namespace :data do
  desc "prevent people from getting hello world problem in tracks they're already doing."
  task :hello do
    require 'active_record'
    require 'db/connection'
    require './lib/exercism/user_exercise'
    DB::Connection.establish

    default_attributes = {
      slug: 'hello-world',
      state: 'done',
      completed_at: Time.now,
      is_nitpicker: false,
      iteration_count: 0,
    }
    sql = "SELECT DISTINCT user_id, language FROM user_exercises"
    ActiveRecord::Base.connection.execute(sql).to_a.each do |row|
      attributes = {
        user_id: row['user_id'],
        language: row['language'],
        key: SecureRandom.uuid.tr('-', ''),
      }.merge(default_attributes)
      UserExercise.create(attributes)
    end
  end

  namespace :cleanup do
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

    # One-off to fix a data problem that I believe
    # was caused by a bug that has since been fixed.
    desc "fix weird state in current submissions"
    task :submissions do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish
      require './lib/exercism/user_exercise'
      require './lib/exercism/submission'
      require './lib/exercism/user'

      sql = <<-SQL
        SELECT * FROM user_exercises WHERE id IN (
          SELECT user_exercise_id FROM submissions
          WHERE state IN ('needs_input', 'pending')
          GROUP BY user_exercise_id
          HAVING COUNT(id) > 1
        )
      SQL
      # I checked the production database
      # and there are only a handful of matches, so
      # we don't risk running out of memory.
      UserExercise.find_by_sql(sql).each do |exercise|
        *superseded, _ = exercise.submissions.order('created_at ASC').to_a
        superseded.each do |submission|
          submission.update_attribute(:state, 'superseded')
        end
      end
    end
  end

  namespace :migrate do
    desc "migrate last viewed"
    task :viewed do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish

      sql = <<-SQL
      INSERT INTO views ( user_id, exercise_id, last_viewed_at, updated_at, created_at ) (
        SELECT
          looks.user_id,
          looks.exercise_id,
          MAX(looks.created_at),
          MAX(looks.created_at),
          MAX(looks.created_at)
        FROM looks
        LEFT JOIN views
        ON looks.user_id=views.user_id AND looks.exercise_id=views.exercise_id
        WHERE views.id IS NULL
        GROUP BY looks.user_id, looks.exercise_id
      )
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

    desc "migrate last activity timestamps"
    task :last_activity do
      require 'active_record'
      require 'db/connection'
      require './lib/exercism'
      DB::Connection.establish

      UserExercise.where('iteration_count > 0').find_each do |exercise|
        submission = Submission.where(user_exercise_id: exercise.id, version: exercise.iteration_count).order('id DESC').limit(1).first
        comment = Comment.joins('INNER JOIN submissions ON submissions.id=comments.submission_id').where('submissions.user_exercise_id=?', exercise.id).order('comments.id DESC').limit(1).first

        latest = [submission, comment].compact.sort_by(&:created_at).last

        if latest.present?
          exercise.last_activity_at = latest.created_at
          exercise.last_activity = latest.activity_description
          exercise.save
        end
      end
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

      User.where('mastery IS NOT NULL').where("mastery != '--- []\n'").find_each do |user|
        Submission.select('DISTINCT language, slug').where(language: user.mastery).each do |submission|
          ACL.authorize(user, submission.problem)
        end
      end
    end

    desc "migrate archived flag on exercises"
    task :archived do
      require 'active_record'
      require 'db/connection'
      require './lib/exercism/user_exercise'
      DB::Connection.establish

      sql = "UPDATE user_exercises SET archived='t' WHERE state='done';"
      ActiveRecord::Base.connection.execute(sql)
    end

    desc "migrate deprecated problems"
    task :deprecated_problems do
      require 'bundler'
      Bundler.require
      require_relative '../exercism'
      # in Ruby
      {
        'point-mutations' => 'hamming'
      }.each do |deprecated, replacement|
        UserExercise.where(language: 'ruby', slug: deprecated).each do |exercise|
          unless UserExercise.where(language: 'ruby', slug: replacement, user_id: exercise.user_id).count > 0
            exercise.slug = replacement
            exercise.save
            exercise.submissions.each do |submission|
              submission.slug = replacement
              submission.save
            end
          end
        end
      end
    end
  end
end
