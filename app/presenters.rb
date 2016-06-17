module ExercismWeb
  module Presenters
    {
      Languages: 'languages',
      Inbox: 'inbox',
      Tracks: 'tracks',
      Setup: 'setup',
      Dashboard: 'dashboard',
      Profile: 'profile',
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('app', 'presenters', file)
    end
  end
end
