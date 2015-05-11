namespace :alerts do
  namespace :hibernation do
    desc "convert hibernation links"
    task :convert_links do
      require 'bundler'
      Bundler.require
      require 'exercism'
      require './lib/exercism/use_cases/hibernation'

      alerts = Alert.where("text LIKE '%has gone into hibernation.'").
                     where("url not like '/exercises/%'")
      alerts.find_each do |alert|
        exercise_key = alert.url.split("/").last
        alert.url = "/exercises/#{exercise_key}"
        alert.save
      end

    end
  end
end
