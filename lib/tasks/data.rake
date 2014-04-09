namespace :data do
  namespace :migrate do
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
        submission.filename = filename
        submission.save
      end
    end
  end
end

