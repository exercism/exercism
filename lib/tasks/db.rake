namespace :db do
  require_relative '../db/config'

  desc "connect to the exercism database"
  task :connect do
    require 'bundler'
    Bundler.require
    require_relative '../db/connection'
    DB::Connection.establish
  end

  desc "migrate your database"
  task :migrate => [:connect] do
    ActiveRecord::Migrator.migrate('./db/migrate')
  end

  task :rollback do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback('./db/migrate', step)
  end

  namespace :migrate do
    task :down => [:connect] do
      version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
      raise 'VERSION is required - To go down one migration, run db:rollback' unless version
      ActiveRecord::Migrator.run(:down, './db/migrate', version)
    end
  end

  desc "set up your database"
  task :setup do
    # Only create user if it doesn't already exist
    stmt = "SELECT 1 AS exists FROM pg_user WHERE usename = '#{config.username}';"
    result = %x|psql -h #{config.host} -p #{config.port} -d postgres -c "#{stmt}"|
    exists = result.split("\n").reject(&:empty?).select {|s| s.strip == "1"}.count == 1
    if !exists
      stmt = <<-STMT
        CREATE USER #{config.username} PASSWORD '#{config.password}' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN
      STMT
      system 'psql', '-d', 'postgres', '-h', config.host, '-p', config.port, '-c', stmt
    end

    # create the database
    system 'createdb', '-h', config.host, '-p', config.port, '-O', config.username, config.database
    raise "Failed to create database" unless $?.success?
  end


  desc "drop and recreate your database"
  task reset: %i(drop create)

  desc "drop your database"
  task :drop do
    system 'dropdb', '-h', config.host, config.database
    raise "Failed to drop database" unless $?.success?
  end

  desc "create your database"
  task :create do
    system 'createdb', '-h', config.host, '-O', config.username, config.database
    raise "Failed to create database" unless $?.success?
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
    DB::Config.new
  end
end
