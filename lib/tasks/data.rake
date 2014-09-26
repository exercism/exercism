namespace :data do
  namespace :seed do
    desc "add recently viewed data for a specific user by username"
    task :looks, [:username, :count] do |t, args|
      if args[:username].nil?
        puts "USAGE: rake db:seed:looks[username]\n   OR: rake db:seed:looks[username,count]"
        exit 1
      end

      require 'bundler'
      Bundler.require
      require 'exercism'

      count = args[:count] || 25
      user = User.find_by_username(args[:username])
      if user.nil?
        puts "Unable to find user with username '#{args[:username]}'"
        exit 1
      end

      UserExercise.order('created_at DESC').limit(count).pluck(:id).each do |id|
        Look.check!(id, user.id)
      end
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
  end

  namespace :migrate do
    desc "migrate logentry keys"
    task :logentries do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish
      require 'json'
      require './lib/exercism/log_entry'
      require './lib/exercism/user'

      LogEntry.find_each do |entry|
        body = JSON.parse(entry.body)
        entry.key = body['key']
        entry.save
      end
    end

    desc "migrate onboarded_at for users"
    task :onboarded_at do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish

      sql = <<-SQL
      SELECT
        c.user_id
      FROM comments c
      INNER JOIN submissions s
      ON c.submission_id=s.id
      WHERE c.user_id != s.user_id
      GROUP BY c.user_id
      HAVING COUNT(DISTINCT s.user_id) > 3
      SQL
      rows = ActiveRecord::Base.connection.execute(sql)
      rows.each do |row|
        id = row['user_id']
        sql2 = <<-SQL
        SELECT commented_at FROM
        (
          SELECT MIN(c.created_at) AS commented_at
          FROM comments c
          INNER JOIN submissions s
          ON c.submission_id=s.id
          WHERE c.user_id != s.user_id
          AND c.user_id=#{id}
          GROUP BY s.user_id
        ) t
        ORDER BY commented_at ASC
        LIMIT 1 OFFSET 2
        SQL
        onboarded_at = ActiveRecord::Base.connection.execute(sql2).to_a.first['commented_at']
        ActiveRecord::Base.connection.execute(
          "UPDATE users SET onboarded_at='#{onboarded_at}' WHERE id=#{id}"
        )
        ActiveRecord::Base.connection.execute(
          "INSERT INTO lifecycle_events (key, user_id, happened_at, created_at, updated_at) VALUES ('onboarded', #{id}, '#{onboarded_at}', '#{onboarded_at}', '#{onboarded_at}')"
        )
      end
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

