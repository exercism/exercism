task :environment do
  require File.expand_path('../../app',
                           File.dirname(__FILE__)) # your Sinatra app
end

namespace :db do
  desc "Make all solution paths relative to the problem directory, not root"
  task solution_path_cleanup: :environment do
    Submission.find_each do |submission|
      new_filename = Code.new(submission.filename)
      begin
        submission.update_attributes!(filename: new_filename)
        print "."
      rescue
        STDERR.puts "\nError updating submission with Key: #{submission.key}\n"
      end
    end

    puts "\n\nDone! #{Submission.all.count} submissions updated"
  end
end
