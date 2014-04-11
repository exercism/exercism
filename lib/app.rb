require 'exercism'
require 'sinatra/petroglyph'
require 'will_paginate'
require 'will_paginate/active_record'

require 'app/presenters/workload'
require 'app/presenters/profile'
require 'app/presenters/sharing'
require 'redesign/presenters/languages'
require 'redesign/presenters/setup'
require 'exercism/xapi'

require 'redesign/helpers/article'
require 'redesign/helpers/fuzzy_time'
require 'redesign/helpers/session'
require 'app/helpers/gravatar_helper'
require 'app/helpers/profile_helper'
require 'app/helpers/site_title_helper'
require 'app/helpers/submissions_helper'
require 'redesign/helpers/markdown'

require 'services'
require 'app/routes'

module ExercismWeb
  class App < Sinatra::Base
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }

    use ExercismWeb::Routes::Stats
    use ExercismWeb::Routes::Static
    use ExercismWeb::Routes::Help
    use ExercismWeb::Routes::Account
    use ExercismWeb::Routes::Legacy
  end
end
