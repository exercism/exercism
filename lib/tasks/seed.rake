namespace :db do
  desc "Fetch seed data from github and save to db/seeds.sql"
  task "seeds:fetch", %s(debug) do |_, args|
    args.with_defaults(debug: ENV["DEBUG"])
    puts "fetching over the wire"
    conn = Faraday.new(url: "https://raw.githubusercontent.com") do |c|
      c.use Faraday::Response::Logger if args.debug
      c.use Faraday::Adapter::NetHttp
    end

    response = conn.get do |req|
      req.url "/exercism/seeds/master/db/seeds.sql"
      req.headers['User-Agent'] = "github.com/exercism/exercism.io"
    end
    File.open("./db/seeds.sql", 'w') do |f|
      f.write response.body
    end
  end

  desc "generate seed data"
  task :seed => ["db:drop", "db:create", "db:migrate"] do
    require 'bundler'
    Bundler.require
    require 'exercism'
    require_relative '../db/config'

    config = DB::Config.new
    system({ 'PGPASSWORD' => config.password },
           'psql', '-h', config.host, '-p', config.port,
                   '-U', config.username,
                   '-d', config.database, '-f', 'db/seeds.sql')

    # Trigger generation of html body
    Comment.find_each { |comment| comment.save }
    # Update nit_count from comments
    Submission.all.each do |s|
      s.nit_count = s.comments.size
      s.save
    end
  end
end
