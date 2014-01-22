unless ENV.fetch('RACK_ENV') { :development }.to_sym == :production
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :test_with_coverage do
    ENV['COVERAGE'] = '1'
    Rake::Task["test"].invoke
    Rake::Task["coveralls:push"].invoke
  end
end
