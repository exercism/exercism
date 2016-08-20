require './config/build_id'
require './config/bugsnag'
require_relative './lib/exercism'

require 'sinatra/petroglyph'
require 'sinatra/reloader'
require 'will_paginate'
require 'will_paginate/active_record'
require 'kss'
require 'tilt/erb'

require_relative './app/presenters'
require_relative './lib/exercism/xapi'

require_relative './app/helpers'
require_relative './app/routes'

module ExercismWeb
  class App < Sinatra::Base
    configure do
      use Rack::Session::Cookie, secret: ENV.fetch('SESSION_SECRET') { "Need to know only." }
    end

    if settings.development?
      use Routes::Backdoor
      register Sinatra::Reloader
    end

    use Routes::Profile
    use Routes::Inbox
    use Routes::Languages
    use Routes::Static
    use Routes::Legacy
    use Routes::Main
    use Routes::Stats
    use Routes::Account
    use Routes::Looks
    use Routes::Notifications
    use Routes::Exercises
    use Routes::UserExercises
    use Routes::Submissions
    use Routes::Solutions
    use Routes::Comments
    use Routes::Tags
    use Routes::Teams
    use Routes::Invitations
    use Routes::Tracks
    use Routes::Sessions
    use Routes::Styleguide
    use Routes::Subscriptions
    use Routes::User
    use Routes::Errors
  end
end
