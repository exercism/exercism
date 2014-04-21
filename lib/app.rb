require 'exercism'
require 'sinatra/petroglyph'
require 'will_paginate'
require 'will_paginate/active_record'

require 'app/presenters/workload'
require 'app/presenters/profile'
require 'app/presenters/sharing'
require 'exercism/xapi'

require 'app/helpers/gravatar_helper'
require 'app/helpers/profile_helper'
require 'app/helpers/site_title_helper'
require 'app/helpers/submissions_helper'

require 'redesign/routes'
require 'redesign/helpers'
require 'redesign/presenters'

require 'services'
require 'app/routes'

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
