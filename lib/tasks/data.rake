namespace :data do
  namespace :cleanup do
    desc "delete orphan notifications"
    task :notifications do
      require 'active_record'
      require 'db/connection'

      DB::Connection.establish

      sql = <<-SQL
      DELETE FROM notifications WHERE id IN (
        SELECT n.id
        FROM notifications n
        LEFT JOIN submissions s ON n.item_id=s.id
        WHERE n.item_type='Submission'
        AND s.id IS NULL
      )
      SQL

      ActiveRecord::Base.connection.execute(sql)
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

    def joined_at
      <<-SQL
        INSERT INTO lifecycle_events
        (user_id, key, happened_at, created_at, updated_at)
        SELECT id, 'joined', created_at, created_at, created_at
        FROM users
      SQL
    end

    def earliest_submission(key)
      <<-SQL
        INSERT INTO lifecycle_events
        (user_id, key, happened_at, created_at, updated_at)
        SELECT user_id, '#{key}', MIN(created_at), MIN(created_at), MIN(created_at)
        FROM submissions s
        GROUP BY user_id
      SQL
    end

    def earliest_comment_given
      <<-SQL
        INSERT INTO lifecycle_events
        (user_id, key, happened_at, created_at, updated_at)
        SELECT c.user_id, 'commented', MIN(c.created_at), MIN(c.created_at), MIN(c.created_at)
        FROM comments c
        INNER JOIN submissions s
        ON c.submission_id=s.id
        WHERE s.user_id != c.user_id
        GROUP BY c.user_id
      SQL
    end

    def earliest_comment_received
      <<-SQL
        INSERT INTO lifecycle_events
        (user_id, key, happened_at, created_at, updated_at)
        SELECT s.user_id, 'received_feedback', MIN(c.created_at), MIN(c.created_at), MIN(c.created_at)
        FROM comments c
        INNER JOIN submissions s
        ON c.submission_id=s.id
        WHERE s.user_id != c.user_id
        GROUP BY s.user_id
      SQL
    end

    def earliest_submission_completed
      <<-SQL
        INSERT INTO lifecycle_events
        (user_id, key, happened_at, created_at, updated_at)
        SELECT s.user_id, 'completed', MIN(s.done_at), MIN(s.done_at), MIN(s.done_at)
        FROM submissions s
        WHERE s.done_at IS NOT NULL
        GROUP BY s.user_id
      SQL
    end

    desc "migrate lifecycle events"
    task :lifecycle do
      require 'bundler'
      Bundler.require
      require_relative '../exercism'

      User.connection.execute(joined_at)
      # We're missing data for 'fetch'. Inserting submit as placeholder.
      User.connection.execute(earliest_submission('fetched'))
      User.connection.execute(earliest_submission('submitted'))
      User.connection.execute(earliest_comment_received)
      User.connection.execute(earliest_comment_given)
      User.connection.execute(earliest_submission_completed)
    end
  end
end

