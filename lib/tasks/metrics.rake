require 'date'
require 'time'

class Metric
  def self.report(sql, headers, fn)
    require 'active_record'
    require 'db/connection'
    DB::Connection.establish

    rows = ActiveRecord::Base.connection.execute(sql)
    puts headers.join(",")
    rows.each do |row|
      puts fn.call(row)
    end
  end
end

def datify(ts)
  Date.strptime(ts, "%Y-%m-%d")
end

def ttf(signup, submit)
  return "never" if submit.nil?

  diff = Time.parse(submit)-Time.parse(signup)

  return 'day' if diff < 24*60*60
  return 'week' if diff < 24*60*60*7
  'more'
end

namespace :metrics do
  namespace :events do
    desc "extract signup events"
    task :signups do
      sql = "SELECT id, created_at FROM users ORDER BY created_at ASC"
      fn = lambda { |row| [row['id'], datify(row['created_at'])].join(",") }
      Metric.report(sql, ["User ID", "Signed Up On"], fn)
    end

    desc "extract comment events"
    task :comments do
      sql = "SELECT id, user_id, created_at FROM comments ORDER BY created_at ASC"
      fn = lambda { |row| [row['id'], row['user_id'], datify(row['created_at'])].join(",") }
      Metric.report(sql, ["Comment ID", "User ID", "Submitted On"], fn)
    end

    desc "extract iteration events"
    task :iterations do
      sql = "SELECT id, user_id, created_at FROM submissions ORDER BY created_at ASC"
      fn = lambda { |row| [row['id'], row['user_id'], datify(row['created_at'])].join(",") }
      Metric.report(sql, ["Iteration ID", "User ID", "Submitted On"], fn)
    end
  end

  desc "extract funnel metrics"
  task :funnel do
    sql = <<-SQL
      SELECT
        u.id,
        u.created_at AS signed_up_at,
        (
          TO_CHAR(EXTRACT(ISOYEAR FROM u.created_at), '9999')
          ||
          TO_CHAR(EXTRACT(WEEK FROM u.created_at), '99')
        ) AS cohort,
        COALESCE(s.yes, 0) AS has_submitted,
        COALESCE(d.yes, 0) AS has_discussed,
        COALESCE(r.yes, 0) AS has_reviewed,
        COALESCE(f.yes, 0) AS has_received_feedback,
        s.first_submission_at
      FROM users u
      LEFT JOIN (
        SELECT user_id, MIN(created_at) AS first_submission_at, 1 AS yes
        FROM submissions
        GROUP BY user_id
      ) AS s
      ON s.user_id=u.id
      LEFT JOIN (
        SELECT DISTINCT(ds.user_id), 1 AS yes
        FROM submissions ds
        INNER JOIN comments dc
        ON ds.id=dc.submission_id
        WHERE ds.user_id=dc.user_id
      ) AS d
      ON d.user_id=u.id
      LEFT JOIN (
        SELECT DISTINCT(rc.user_id), 1 AS yes
        FROM submissions rs
        INNER JOIN comments rc
        ON rs.id=rc.submission_id
      ) AS r
      ON r.user_id=u.id
      LEFT JOIN (
        SELECT DISTINCT(fs.user_id), 1 AS yes
        FROM submissions fs
        INNER JOIN comments fc
        ON fs.id=fc.submission_id
      ) AS f
      ON f.user_id=u.id
      WHERE s.first_submission_at IS NOT NULL
    SQL
    fn = lambda { |row|
      [
        row['id'],
        row['cohort'].gsub(' ', ''),
        row['has_submitted'],
        row['has_discussed'],
        row['has_reviewed'],
        row['has_received_feedback'],
        ttf(row['signed_up_at'], row['first_submission_at']),
      ].join(",")
    }
    Metric.report(sql, ["User ID", "Cohort", "Submitted", "Discussed", "Reviewed", "Got Feedback", "Time to First Submission"], fn)
  end
end
