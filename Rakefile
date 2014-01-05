ENV['NEWRELIC_ENABLE'] = "false"

$:.unshift File.expand_path("./../lib", __FILE__)
Dir.glob("lib/tasks/*.rake").each { |r| import r }

require 'rake/testtask'

Rake::TestTask.new do |t|
  require 'bundler'
  Bundler.require
  t.test_files = FileList['test/**/*_test.rb'].exclude('test/fixtures/**/*')
end

namespace :db do
  desc "migrate your database"
  task :migrate do
    require 'bundler'
    Bundler.require
    require_relative 'lib/db/connection'
    DB::Connection.establish
    ActiveRecord::Migrator.migrate('./db/migrate')
  end
end

desc "Run each test file independently"
namespace :test do
  task :each do
    files = FileList['test/**/*_test.rb'].exclude('test/fixtures/**/*')
    failures = files.reject do |file|
      system("ruby #{file}")
    end

    unless failures.empty?
      puts "FAILURES IN:"
      failures.each do |failure|
        puts failure
      end
      exit 1
    end
  end
end

task default: :test
