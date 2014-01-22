namespace :strip do
  desc "strip whitespace from code examples"
  task :whitespace do
    require 'active_record'
    require './lib/exercism/submission'
    require './lib/exercism/user'
    require 'db/connection'
    DB::Connection.establish

    Submission.find_each do |s|
      s.code = s.code.gsub(/\n*\z|\A\n*/, "")
      s.save
      print '.'
    end
    puts
  end
end

