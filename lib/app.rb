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
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }

    if settings.development?
      use ExercismWeb::Routes::Backdoor
    end

    use ExercismIO::Routes::Help
    use ExercismWeb::Routes::Legacy
    use ExercismWeb::Routes::Sessions
    use ExercismWeb::Routes::Stats
    use ExercismWeb::Routes::Static
    use ExercismWeb::Routes::Account
    use ExercismWeb::Routes::Metadata
    use ExercismWeb::Routes::Exercises
    use ExercismWeb::Routes::Solutions
    use ExercismWeb::Routes::Comments
    use ExercismWeb::Routes::Teams
    use ExercismWeb::Routes::User
    use ExercismWeb::Routes::Errors
  end
end
