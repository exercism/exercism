module ExercismIO
  module Helpers
    {
      :URL => 'url',
      :Config => 'config',
      :Session => 'session',
      :Article => 'article',
      :Component => 'component',
      :FuzzyTime => 'fuzzy_time',
      :Markdown => 'markdown'
    }.each do |name, file|
      autoload name, ['redesign', 'helpers', file].join('/')
    end
  end
end
