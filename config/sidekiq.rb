if ENV['RACK_ENV'].to_sym == :production
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDISTOGO_URL"]}
  end
end
