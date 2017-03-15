require 'flipper_app/authorize'

module FlipperApp
  def self.generator
    lambda do |builder|
      builder.use Rack::Session::Cookie, secret: ENV.fetch('SESSION_SECRET', ExercismWeb::DEFAULT_SESSION_KEY)
      builder.use FlipperApp::Authorize
    end
  end
end
