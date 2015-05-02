$:.unshift File.expand_path("./../../lib", __FILE__)
require 'bundler'
Bundler.require
require 'exercism'

ENV['RACK_ENV'] ||= 'development'

def user(username)
  User.find_by_username(username)
end

def submission(key)
  Submission.find_by_key(key)
end

def exercise(key)
  UserExercise.find_by_key(key)
end
