require './config/build_id'
require './config/bugsnag'
require_relative 'exercism'

require 'sinatra/petroglyph'
require 'sinatra/reloader'
require 'will_paginate'
require 'will_paginate/active_record'
require 'kss'

require_relative './app/presenters'
require_relative './app/presenters/workload'
require_relative './app/presenters/profile'
require_relative './app/presenters/sharing'
require_relative './exercism/xapi'

require_relative './app/helpers'
require_relative './app/helpers/gravatar_helper'
require_relative './app/helpers/profile_helper'
require_relative './app/helpers/site_title_helper'
require_relative './app/helpers/submissions_helper'

require_relative './app/routes'

module ExercismWeb
  class App < Sinatra::Base
    configure do
      enable :sessions
      set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
    end

    if settings.development?
      use Routes::Backdoor
      register Sinatra::Reloader
    end

    use Routes::Static
    use Routes::Legacy
    use Routes::Main
    use Routes::OnboardingSteps
    use Routes::Sessions
    use Routes::Stats
    use Routes::Conversations
    use Routes::Account
    use Routes::Metadata
    use Routes::Looks
    use Routes::Notifications
    use Routes::Exercises
    use Routes::Solutions
    use Routes::Comments
    use Routes::Nits
    use Routes::Teams
    use Routes::Styleguide
    use Routes::User
    use Routes::CommentThreads
    use Routes::Errors
  end
end
