namespace :db do
  desc "generate seed data"
  task :seed do

    %x{dropdb exercism_development}
    %x{createdb -O exercism exercism_development}
    %x{psql -U exercism -d exercism_development -f db/seeds.sql}

    require 'bundler'
    Bundler.require
    require 'exercism'
    # Trigger generation of html body
    Comment.find_each { |comment| comment.save }

  end
end
