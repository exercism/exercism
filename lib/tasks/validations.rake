namespace :validate do
  desc "validate all assignment files"
  task :assignments do

    $:.unshift File.expand_path('../..', __FILE__)
    require 'exercism'

    missing_tests = []
    missing_examples = []

    Exercism.current_curriculum.trails.each do |name, trail|
      trail.exercises.each do |exercise|
        assignment = trail.assign(exercise.slug)
        case
        when ! assignment.test_file_exists?
          missing_tests << assignment.test_file_path
          print 'T'
        when ! assignment.example_file_exists?
          missing_examples << assignment.example_file_path
          print 'E'
        else
          print '.'
        end
      end
    end

    puts
    puts missing_tests.unshift("\n*** Missing Tests: ***").join("\n") if missing_tests.any?
    puts missing_examples.unshift("\n*** Missing Examples: ***").join("\n") if missing_examples.any?
    puts "All systems go" unless missing_tests.any? || missing_examples.any?
    puts

  end
end
