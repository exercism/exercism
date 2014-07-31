namespace :db do
  task "seeds:fetch", %s(debug) do |t, args|
    args.with_defaults(debug: ENV["DEBUG"])
    puts "fetching over the wire"
    conn = Faraday.new(url: "https://raw.githubusercontent.com") do |c|
      c.use Faraday::Response::Logger if args.debug
      c.use Faraday::Adapter::NetHttp
    end

    %w(schema migrations seeds).each do |file|
      response = conn.get do |req|
        req.url "/exercism/seeds/master/db/#{file}.sql"
        req.headers['User-Agent'] = "github.com/exercism/exercism.io"
      end
      File.open("./db/#{file}.sql", 'w') do |f|
        f.write response.body
      end
    end
  end

  desc "generate seed data"
  task :seed do
    require 'bundler'
    Bundler.require
    require 'exercism'

    %x{dropdb exercism_development -U exercism}
    %x{createdb -O exercism exercism_development -U exercism}
    Rake::Task['db:seeds:fetch'].invoke
    %w(schema migrations seeds).each do |file|
      %x{psql -U exercism -d exercism_development -f db/#{file}.sql}
    end

    # Trigger generation of html body
    Comment.find_each { |comment| comment.save }
  end
end
