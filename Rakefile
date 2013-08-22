$:.unshift File.expand_path("./../lib", __FILE__)
Dir.glob("lib/tasks/*.rake").each { |r| import r }

require 'rake/testtask'

Rake::TestTask.new do |t|
  require 'bundler'
  Bundler.require
  ENV['RACK_ENV'] = 'test'
  t.pattern = "test/**/*_test.rb"
end

task default: :test

