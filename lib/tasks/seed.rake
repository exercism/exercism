namespace :db do
  desc "Fetch seed data from github and save to db/seeds.sql"
  task "seeds:fetch", %s(debug) do |_, args|
    require 'faraday'
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

  desc "reset db and reseed data"
  task reseed: ["db:drop", "db:create", "db:migrate", "db:seed"]

  desc "generate seed data"
  task seed: [:connection] do
    require_comments
    config = DB::Config.new
    # rubocop:disable Style/AlignParameters
    system({ 'PGPASSWORD' => config.password },
           'psql', '-h', config.host, '-p', config.port,
                   '-U', config.username,
                   '-d', config.database, '-f', 'db/seeds.sql')
    # rubocop:enable Style/AlignParameters

    # Trigger generation of html body
    Comment.find_each(&:save)
  end

  desc "generate seed data on Heroku"
  task heroku_seed: [:connection] do
    require_comments
    if ENV['DATABASE_URL']
      system('psql', ENV['DATABASE_URL'], '-f', 'db/seeds.sql')
      # Trigger generation of html body
      Comment.find_each(&:save)
    else
      puts "No DATABASE_URL environment variable found. Did you add postgresql addon?"
      puts "If you're trying to run this task on your local machine, prefer the `db:seed` task instead"
    end
  end

  def require_comments
    require 'exercism/converts_markdown_to_html'
    require 'exercism/comment'
  end
end
