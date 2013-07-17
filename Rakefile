$:.unshift File.expand_path("./../lib", __FILE__)
require 'rake/testtask'

Rake::TestTask.new do |t|
  require 'bundler'
  Bundler.require
  t.pattern = "test/**/*_test.rb"
end

task default: :test

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
        begin
          # Loading the assignments will break if any of the
          # files are missing or named incorrectly.
          assignment.readme
          assignment.test_file
          assignment.example
        rescue => e
          puts "#{exercise} is broken. #{e.message}"
          broken = true
        end
      end
    end
    exit 1 if broken
  end
end
