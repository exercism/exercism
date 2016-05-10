begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError => error
  puts "RuboCop's rake task could not be loaded"
  puts error.message
end
