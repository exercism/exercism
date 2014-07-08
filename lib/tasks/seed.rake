namespace :db do
  desc "generate seed data"
  task :seed do
    require 'bundler'
    Bundler.require
    require 'exercism'

    # %x{dropdb exercism_development -U exercism}
    # %x{createdb -O exercism exercism_development -U exercism}

    conn = Faraday.new(:url => "https://raw.githubusercontent.com") do |c|
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end

    response = conn.get do |req|
      req.url "/exercism/seeds/master/db/seeds.sql"
      req.headers['User-Agent'] = "github.com/exercism/exercism.io"
    end
    File.open('./db/seeds.sql', 'w') do |f|
      f.write response.body
    end

    %x{psql -U exercism -d exercism_development -f db/seeds.sql}

    # Trigger generation of html body
    Comment.find_each { |comment| comment.save }
  end
end
