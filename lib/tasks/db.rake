namespace :db do
  require 'English'

  desc "migrate your database"
  task migrate: [:connection] do
    ActiveRecord::Migrator.migrate('./db/migrate')
  end

  task rollback: [:connection] do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback('./db/migrate', step)
  end

  namespace :migrate do
    task down: [:connection] do
      version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
      fail 'VERSION is required - To go down one migration, run db:rollback' unless version
      ActiveRecord::Migrator.run(:down, './db/migrate', version)
    end
  end

  desc "set up your database"
  task :setup do
    require 'open3'
    require 'db/connection'
    user = DB::Connection.escape(config.username)
    pass = DB::Connection.escape(config.password)

    # Only create user if it doesn't already exist
    sql = "SELECT 'user exists' FROM pg_user WHERE usename = '#{user}'"
    out, err, status = Open3.capture3('psql', '-t', '-h', config.host,
                                      '-p', config.port, '-c', sql, '-d', 'postgres')
    fail "db:setup - Couldn't query users: #{err}" unless status.success?

    unless out.include?('user exists')
      sql = "CREATE USER #{user} PASSWORD '#{pass}' " \
            'SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN'
      system 'psql', '-h', config.host, '-p', config.port, '-c', sql, '-d', 'postgres'
    end

    if system "psql -lqtA | grep -q #{config.database}"
      $stdout.puts "#{config.database} already exists"
    else
      system 'createdb', '-h', config.host, '-p', config.port, '-U', config.username, config.database
      unless $CHILD_STATUS.success?
        fail "Failed to create database"
      end
    end
  end

  desc "drop and recreate your database"
  task reset: %i(drop create)

  desc "drop your database"
  task :drop do
    system 'dropdb', '-h', config.host, config.database, '-U', config.username
    fail "Failed to drop database" unless $CHILD_STATUS.success?
  end

  desc "create your database"
  task :create do
    system 'createdb', '-h', config.host, config.database, '-U', config.username
    fail "Failed to create database" unless $CHILD_STATUS.success?
  end

  desc 'set the database up from scratch'
  task from_scratch: %i(setup migrate seeds:fetch seed)

  namespace :generate do
    desc "generate migration"
    task :migration do
      require 'active_support/all'
      name = ENV['name'] || ENV['NAME']
      if name.nil?
        $stderr.puts "Usage: rake db:generate:migration name=the_name_of_your_migration"
        exit 1
      end

      now = Time.now.strftime("%Y%m%d%H%M")
      filename = "./db/migrate/#{now}_#{name.underscore}.rb"
      text = <<-text
class #{name.camelcase} < ActiveRecord::Migration
  def change
  end
end
      text
      File.open(filename, 'w') do |f|
        f.puts text
      end
    end
  end

  def config
    require 'db/config'
    DB::Config.new
  end
end
