namespace :data do
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

    desc "migrate nitpicker status"
    task :nitpicker_status do
      require 'bundler'
      Bundler.require
      require_relative '../db/connection'
      DB::Connection.establish

      sql = "UPDATE user_exercises SET is_nitpicker='t' WHERE state='done'"
      ActiveRecord::Base.connection.execute(sql)
    end

    desc "migrate file names"
    task :file_names do
      require 'bundler'
      Bundler.require
      require 'exercism'

      Submission.find_each do |submission|
        ext = Code::LANGUAGES.invert[submission.language]
        filename = "#{submission.slug}.#{ext}"
        submission.filename ||= filename
        submission.save
      end
    end
  end
end

