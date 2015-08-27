module ExercismWeb
  module Presenters
    {
      Languages: 'languages',
      Docs: 'docs',
      Tracks: 'tracks',
      Setup: 'setup',
      Dashboard: 'dashboard',
      Progress: 'progress',
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('lib', 'app', 'presenters', file)
    end
  end
end
