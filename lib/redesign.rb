require 'sinatra/base'
require 'redesign/routes'
require 'redesign/helpers'

module ExercismIO
  class Redesign < Sinatra::Application
    configure do
      use Rack::Session::Cookie,
        :key => 'rack.session',
        :path => '/redesign',
        :expire_after => 2592000,
        :secret => ENV.fetch('SESSION_SECRET') { 'Need to know only.' } + 'redesign'
    end

    use Routes::Home
    use Routes::Static
    use Routes::Help
    use Routes::Account
    use Routes::Session
  end
end
