module ExercismWeb
  module Presenters
    {
      Inbox: 'inbox',
      Setup: 'setup',
      Dashboard: 'dashboard',
      Profile: 'profile',
      Track: 'track',
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('app', 'presenters', file)
    end
  end
end
