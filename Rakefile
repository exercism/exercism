$:.unshift File.expand_path("./../lib", __FILE__)
Dir.glob("lib/tasks/*.rake").each { |r| import r }

require 'rake/testtask'

Rake::TestTask.new do |t|
  require 'bundler'
  Bundler.require
  t.pattern = "test/**/*_test.rb"
end

namespace :db do
  desc "migrate your database"
  task :migrate do
    require 'bundler'
    Bundler.require
    require_relative 'lib/exercism/manages_database'
    ManagesDatabase.establish_connection
    ActiveRecord::Migrator.migrate('lib/db/migrate')
  end
end

task default: :test
