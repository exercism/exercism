require 'sinatra/base'

module ExercismIO
  ROOT = 'redesign'
end

['routes', 'helpers', 'presenters'].each do |file|
  require [ExercismIO::ROOT, file].join('/')
end

module ExercismIO
  class Redesign < Sinatra::Application
    configure do
      use Rack::Session::Cookie,
        :key => 'rack.session',
        :path => '/redesign',
        :expire_after => 2592000,
        :secret => ENV.fetch('SESSION_SECRET') { 'Need to know only.' } + ExercismIO::ROOT
    end

    use Routes::Static
    use Routes::Help
    use Routes::Account
    use Routes::Session
    use Routes::Exercises
    use Routes::User
    use Routes::Teams
  end
end
