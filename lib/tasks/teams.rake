namespace :teams do
  desc "migrate team creators to team managers"
  task :migrate_managers do
    require 'bundler'
    Bundler.require
    require 'exercism'

    Team.all.each do |team|
      team.managed_by(team.creator)
    end
  end
end
