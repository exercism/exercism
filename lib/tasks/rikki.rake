namespace :rikki do
  desc "dump go stuff for experimentation"
  task dump: [:connection] do
    class Submission < ActiveRecord::Base
      serialize :solution, JSON
    end
    require 'fileutils'

    Submission.where(language: 'go').find_each do |submission|
      dir = File.join('.', 'rikki', submission.key)
      FileUtils.mkdir_p(dir)

      submission.solution.each do |name, code|
        filename = File.join(dir, File.basename(name))
        File.open(filename, 'w') do |f|
          f.write code
        end
      end
    end
  end

  desc "comment on old go issues"
  task go: [:connection] do
    require 'jobs/analyze'

    # Select only:
    # - the most recent submission
    # - where nobody has commented
    # - that is not archived
    sql = <<-SQL
    SELECT s.key AS uuid
    FROM submissions s
    INNER JOIN user_exercises ex
    ON s.user_exercise_id=ex.id
    LEFT JOIN (
      SELECT COUNT(comments.id) AS comment_count, submissions.id
      FROM comments
      INNER JOIN submissions
      ON comments.submission_id=submissions.id
      WHERE comments.user_id<>submissions.user_id
      GROUP BY submissions.id
    ) t
    ON t.id=s.id
    WHERE s.language='go'
    AND ex.iteration_count=s.version
    AND (t.comment_count=0 OR t.id IS NULL)
    AND ex.archived='f'
    SQL

    ActiveRecord::Base.connection.execute(sql).to_a.each do |row|
      Jobs::Analyze.perform_async(row["uuid"])
    end
  end
end
