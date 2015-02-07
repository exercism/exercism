module ExercismWeb
  module Helpers
    {
      Session: 'session',
      FuzzyTime: 'fuzzy_time',
      NgEsc: 'ng_esc',
      Markdown: 'markdown',
      NotificationCount: 'notification_count'
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('lib', 'app', 'helpers', file)
    end
  end
end
