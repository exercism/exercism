Bugsnag.configure do |config|
  config.release_stage = ENV["RACK_ENV"]
  config.notify_release_stages = ["production", "development"]
  config.api_key = ENV['BUGSNAG_API_KEY']
  config.project_root = File.expand_path("../..", __FILE__)
end

