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
