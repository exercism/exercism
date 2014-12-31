namespace :data do
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
    desc "move comment-threads into regular comments"
    task :comments do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish
      require 'json'
      require './lib/exercism/comment'
      require './lib/exercism/comment_thread'
      require './lib/exercism/submission'
      require './lib/exercism/converts_markdown_to_html'

      CommentThread.find_each do |ct|
        s = ct.comment.submission

        Comment.create(
          user_id: ct.user_id,
          body: ct.body,
          submission_id: s.id,
          created_at: ct.created_at,
          updated_at: ct.updated_at
        )

        ct.destroy
      end
    end

    desc "allow multiple files in solutions"
    task :solutions do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish
      require 'json'
      require './lib/exercism/submission'
      require './lib/exercism/user'

      Submission.where(solution: 'null').find_each do |submission|
        submission.solution = {submission.filename => submission.code}
        submission.save
        puts "updated submission %d" % submission.id
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
  end
end
