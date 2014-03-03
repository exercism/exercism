require 'sinatra/base'
require 'redesign/routes'
require 'redesign/helpers'

module ExercismIO
  class Redesign < Sinatra::Application
    configure do
      use Rack::Session::Cookie,
        :key => 'rack.session',
        :path => '/',
        :expire_after => 2592000,
        :secret => ENV.fetch('SESSION_SECRET') { 'Need to know only.' }
    end

    use Routes::Home
    use Routes::Static
    use Routes::Help
  end
end
