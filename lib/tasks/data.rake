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
  end

  namespace :migrate do
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
