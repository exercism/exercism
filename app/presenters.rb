module ExercismWeb
  module Presenters
    {
      Assignment: 'assignment',
      Languages: 'languages',
      Inbox: 'inbox',
      Tracks: 'tracks',
      Setup: 'setup',
      Dashboard: 'dashboard',
      Progress: 'progress',
      Profile: 'profile',
      Sharing: 'sharing'
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('app', 'presenters', file)
    end
  end
end
