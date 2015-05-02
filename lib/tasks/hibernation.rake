namespace :submissions do
  desc "trigger hibernation state for aging/stale submissions"
  task :hibernate do
    require 'bundler'
    Bundler.require
    require 'exercism'
    require './lib/exercism/use_cases/hibernation'

    Submission.aging.find_each do |submission|
      Hibernation.new(submission).process
    end

  end
end

