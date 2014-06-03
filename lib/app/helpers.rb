module ExercismWeb
  module Helpers
    {
      :Session => 'session',
      :Article => 'article',
      :FuzzyTime => 'fuzzy_time',
      :Markdown => 'markdown',
      :Setup => 'setup'
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('lib', 'app', 'helpers', file)
    end
  end
end
