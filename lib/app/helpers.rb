module ExercismWeb
  module Helpers
    {
      Session: 'session',
      FuzzyTime: 'fuzzy_time',
      Markdown: 'markdown',
      Setup: 'setup',
      NotificationCount: 'notification_count'
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('lib', 'app', 'helpers', file)
    end
  end
end
