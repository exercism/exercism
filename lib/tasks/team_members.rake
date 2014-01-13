namespace :migrate do
  desc "Make all current team members confirmed"
  task :team_members do
    require 'bundler'
    Bundler.require
    require 'exercism'

    TeamMembership.update_all(confirmed: true)
  end
end
