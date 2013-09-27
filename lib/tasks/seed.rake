namespace :db do
  desc "generate seed data"
  task :seed, :size do |t, args|
    args.with_defaults(size: 10)
    require 'bundler'
    Bundler.require
    require 'exercism'
    require 'seed'

    Seed.reset
    Seed.generate(args[:size].to_i)
    Seed.generate_default_users
  end
end
