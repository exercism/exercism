namespace :data do
  namespace :github do
    desc "update missing usernames"
    task usernames: [:connection] do
      class MinimalUser < ActiveRecord::Base
        self.table_name = 'users'
      end
      require 'octokit'

      client = Octokit::Client.new(access_token: ENV['EXERCISM_OAUTH_TOKEN'])
      client.rate_limit

      MinimalUser.where("username=''").find_each.each do |minimal_user|
        response = client.last_response
        if response.headers["x-ratelimit-remaining"].to_i.zero?
          seconds = response.headers["x-ratelimit-reset"].to_i - Time.now.utc.to_i
          puts "sleeping for %d seconds" % seconds
          sleep seconds
        end

        begin
          user = client.user(minimal_user.github_id)
          attributes = {
            :username => user.login,
            :email => user.email,
            :name => user.name || '',
            :bio => user.bio,
          }
          minimal_user.update_attributes(attributes)
        rescue Octokit::NotFound
          username = ""
          if minimal_user.github_id.present?
            username = "deleted-github-user-%d" % minimal_user.github_id
          end
          minimal_user.update_attributes(:username => username, :email => nil)
        end
      end
    end

    desc "fetch extra GitHub user data for the etl"
    task users: [:connection] do
      class MinimalUser < ActiveRecord::Base
        self.table_name = 'users'
      end
      require 'octokit'

      client = Octokit::Client.new(access_token: ENV['EXERCISM_OAUTH_TOKEN'])
      client.rate_limit

      MinimalUser.where("name IS NULL").find_each.each do |minimal_user|
        response = client.last_response
        if response.headers["x-ratelimit-remaining"].to_i.zero?
          seconds = response.headers["x-ratelimit-reset"].to_i - Time.now.utc.to_i
          puts "sleeping for %d seconds" % seconds
          sleep seconds
        end

        begin
          user = client.user(minimal_user.github_id)
          attributes = {
            :username => user.login,
            :email => user.email,
            :name => user.name || '',
            :bio => user.bio,
          }
          minimal_user.update_attributes(attributes)
        rescue Octokit::NotFound
          username = ""
          if minimal_user.github_id.present?
            username = "deleted-github-user-%d" % minimal_user.github_id
          end
          minimal_user.update_attributes(:username => username, :email => nil)
        end
      end
    end
  end

  namespace :cleanup do
    desc "clean up random stuff"
    task random: [:connection] do
      require 'exercism'

      track_ids = %w(bash c groovy)
      src = 'point-mutations'
      dst = 'hamming'
      Submission.where(language: track_ids, slug: src).each do |submission|
        begin
          submission.user_exercise.update_attributes(slug: dst)
        rescue
          exercise = UserExercise.find_by(slug: dst, language: submission.language, user_id: submission.user_id)
          submission.user_exercise_id = exercise.id
        end
        submission.slug = dst
        submission.save
      end
      UserExercise.where(language: track_ids, slug: src).destroy_all
    end

    desc "delete duplicate emails"
    task emails: [:connection] do
      require 'exercism'

      sql = <<-SQL
        UPDATE users
        SET email=NULL
        WHERE id IN (
          SELECT MAX(id) FROM users WHERE email IN (
            SELECT email
            FROM users
            GROUP BY email
            HAVING COUNT(id) > 1
          )
          GROUP BY email
        )
      SQL
      User.connection.execute(sql)
    end

    desc "delete orphan submissions"
    task submissions: [:connection] do
      require 'exercism'

      sql = <<-SQL
      SELECT s.id
      FROM submissions s
      LEFT JOIN user_exercises ux
      ON s.user_exercise_id=ux.id
      WHERE ux.id IS NULL
      SQL
      ids = Submission.connection.execute(sql).map {|row| row["id"]}
      sql = <<-SQL % ids.join(",")
      DELETE FROM submissions WHERE id IN (%s)
      SQL
      Submission.connection.execute(sql)
    end

    desc "delete empty solutions"
    task eempty: [:connection] do
      require 'exercism'

      Submission.where("octet_length(solution)<100").each do |submission|
        exercise = submission.user_exercise

        files = submission.solution
        files = files.reject do |filename, contents|
          contents.strip.empty?
        end
        if files != submission.solution
          if files.empty?
            submission.destroy
          else
            submission.solution = files
            submission.save
          end

          if exercise.reload.submissions.count == 0
            exercise.destroy
          else
            exercise.iteration_count = exercise.submissions.count
            exercise.last_activity = "Submitted an iteration"
            exercise.last_activity_at = exercise.submissions.last.created_at
            exercise.save
          end
        end
      end
    end

    desc "delete massive binaries submitted as solutions"
    task etoobig: [:connection] do
      require 'exercism'

      Submission.where("octet_length(solution)>65535").each do |submission|
        exercise = submission.user_exercise

        if submission.solution.count == 1
          submission.comments.destroy_all
          submission.destroy
        else
          files = submission.solution
          files = files.reject do |filename, contents|
            contents.bytesize > 65_535
          end
          submission.solution = files
          submission.save
        end
        if exercise.reload.submissions.count == 0
          exercise.destroy
        else
          exercise.iteration_count = exercise.submissions.count
          exercise.last_activity = "Submitted an iteration"
          exercise.last_activity_at = exercise.submissions.last.created_at
          exercise.save
        end
      end
    end

    desc "migrate nimrod exercises to nim"
    task nimrod: [:connection] do
      require 'exercism'

      UserExercise.where(language: 'nimrod').each do |legacy_exercise|
        begin
          legacy_exercise.update_attributes(language: 'nim')
          legacy_exercise.submissions.update_all(language: 'nim')
        rescue
          exercise = UserExercise.find_by(user_id: legacy_exercise.user_id, language: 'nim', slug: legacy_exercise.slug)
          puts "repointing submissions on %d/%s to %d (%s)" % [legacy_exercise.id, legacy_exercise.slug, exercise.id, legacy_exercise.user.username]
          legacy_exercise.submissions.update_all(user_exercise_id: exercise.id, language: 'nim')

          exercise.reload.submissions.order(:created_at).each.with_index do |submission, i|
            submission.version = i+1
            submission.save
          end
          if legacy_exercise.reload.submissions.count > 0
            "we have a problem in %d" % legacy_exercise.id
          else
            legacy_exercise.destroy
          end
        end
      end
    end

    desc "normalize action names"
    task notifications: [:connection] do
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
    task missing_language: [:connection] do
      # Submission#before_create requires Exercism.uuid
      require 'exercism'

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
    task iteration_counts: [:connection] do

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
    task comments: [:connection] do

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
    task subscriptions: [:connection] do

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
    task last_iteration: [:connection] do

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
    task last_activity: [:connection] do

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
    task acls: [:connection] do
      require 'exercism/acl'
      require 'exercism/named'
      require 'exercism/problem'
      require 'exercism/submission'
      require 'exercism/user'

      Submission.find_each do |submission|
        if submission.user.present?
          ACL.authorize(submission.user, submission.problem)
        end
      end
    end

    desc "migrate mentor acls"
    task mentor_acls: [:connection] do
      require 'exercism/acl'
      require 'exercism/named'
      require 'exercism/problem'
      require 'exercism/submission'
      require 'exercism/user'

      User.where('track_mentor IS NOT NULL').where("track_mentor != '--- []\n'").find_each do |user|
        Submission.select('DISTINCT language, slug').where(language: user.track_mentor).each do |submission|
          ACL.authorize(user, submission.problem)
        end
      end
    end

    desc "migrate unconfirmed memberships to membership_invites"
    task migrate_unconfirmed_memberships: [:connection] do

      sql = <<-SQL
        INSERT INTO team_membership_invites(team_id, user_id, inviter_id, created_at, updated_at)
        SELECT team_id, user_id, inviter_id, created_at, updated_at
        FROM team_memberships
        WHERE confirmed is FALSE
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end
  end

  namespace :generate do
    desc "generate N users, typically for performance testing"
    task users: [:connection] do
      n = ENV['N'].to_i
      abort 'specify the number of users to generate: N=<count>' if n.zero?
      puts "Generating #{n} users"
      ActiveRecord::Base.connection.execute <<~SQL
        INSERT INTO users (crc32mod100, created_at, updated_at) (
          SELECT
            floor(random() * 100),
            now() - '4 years'::interval * abs(1 - random() ^ 2) AS created_at,
            now() AS updated_at
          FROM generate_series(1, #{n})
        )
      SQL
    end

    desc "generate N comments, typically for performance testing"
    task comments: [:connection] do
      n = ENV['N'].to_i
      abort 'specify the number of comments to generate: N=<count>' if n.zero?
      puts "Generating #{n} comments"
      ActiveRecord::Base.connection.execute <<~SQL
        INSERT INTO comments (submission_id, user_id, body, html_body, created_at, updated_at) (
          SELECT
            submission_id,
            user_id,
            body,
            html_body,
            now() - '4 years'::interval * abs(1 - random() ^ 2) AS created_at,
            now() AS updated_at
          FROM generate_series(1, #{n})
          JOIN (SELECT id submission_id, row_number() OVER (ORDER BY random()) AS submissions_row_number FROM submissions) random_submissions
            ON submissions_row_number = generate_series % (SELECT count(*) FROM submissions)
          JOIN (SELECT id user_id,       row_number() OVER (ORDER BY random()) AS users_row_number FROM users) random_users
            ON users_row_number       = generate_series % (SELECT count(*) FROM users)
          JOIN (SELECT body, html_body,  row_number() OVER (ORDER BY random()) AS comments_row_number FROM comments) random_comments
            ON comments_row_number    = generate_series % (SELECT count(*) FROM comments)
        )
      SQL
    end
  end
end
