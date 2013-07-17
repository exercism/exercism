class Assignment
  def files
    [
      path_to(test_file),
      path_to_shared(instructions_file),
      path_to_shared(data_file),
      path_to(example_file)
    ]
  end

  def missing_files?
    missing_files.size > 0
  end

  def missing_files
    @missing_files ||= files.reject {|file| File.exists?(file)}
  end
end

namespace :assignments do
  desc "verify validity of assignments"
  task :verify do
    require 'bundler'
    Bundler.require
    require 'exercism'

    broken = false

    Exercism.current_curriculum.trails.each do |_, trail|
      trail.exercises.each do |exercise|
        assignment = trail.assign(exercise.slug)

        if assignment.missing_files?
          broken = true
          puts "#{assignment.exercise} is missing:"
          assignment.missing_files.each do |file|
            puts "\t#{file}"
          end
        end
      end
    end
    exit 1 if broken
  end
end

