class Assignment
  def files_on_hand
    [
      path_to(test_file),
      path_to_shared(instructions_file),
      path_to_shared(data_file),
    ]
  end

  def path_to_shared(file)
    File.join(data_dir, 'shared', file)
  end

  def instructions_file
    "#{slug}.md"
  end

  def data_file
    "#{slug}.yml"
  end

  def missing_files?
    missing_files.size > 0
  end

  def missing_files
    @missing_files ||= files_on_hand.reject {|file| File.exists?(file)}
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

