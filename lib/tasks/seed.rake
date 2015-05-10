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
  task :seed do
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

  desc "add recently viewed data for a specific (test) user by username"
  task "seed:looks", [:username, :count] do |_, args|
    if args[:username].nil?
      puts "USAGE: rake db:seed:looks[username]\n   OR: rake db:seed:looks[username,count]"
      exit 1
    end

    require 'bundler'
    Bundler.require
    require 'exercism'

    count = args[:count] || 25
    user = User.find_by_username(args[:username])
    if user.nil?
      puts "Unable to find user with username '#{args[:username]}'"
      exit 1
    end

    UserExercise.order('created_at DESC').limit(count).pluck(:id).each do |id|
      Look.check!(id, user.id)
    end
  end
end
