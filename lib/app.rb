require_relative './exercism'

require 'sinatra/petroglyph'
require 'will_paginate'
require 'will_paginate/active_record'

require_relative './app/presenters/workload'
require_relative './app/presenters/profile'
require_relative './app/presenters/sharing'
require_relative './exercism/xapi'

require_relative './app/helpers/gravatar_helper'
require_relative './app/helpers/profile_helper'
require_relative './app/helpers/site_title_helper'
require_relative './app/helpers/submissions_helper'

require_relative './redesign/presenters'
require_relative './redesign/helpers'
require_relative './redesign/routes'

require_relative './services'
require_relative './app/routes'

module ExercismWeb
  class App < Sinatra::Base
    configure do
      enable :sessions
      set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
    end

    if settings.development?
      use Routes::Backdoor
    end

    use ExercismIO::Routes::Help

    use Routes::Legacy
    use Routes::Sessions
    use Routes::Stats
    use Routes::Static
    use Routes::Account
    use Routes::Metadata
    use Routes::Looks
    use Routes::Exercises
    use Routes::Solutions
    use Routes::Comments
    use Routes::Teams
    use Routes::User
    use Routes::Errors
  end
end
