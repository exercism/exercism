module ExercismIO
  module Helpers
    {
      :URL => 'url',
      :Config => 'config',
      :Session => 'session',
      :Article => 'article',
      :Component => 'component',
      :FuzzyTime => 'fuzzy_time'
    }.each do |name, file|
      autoload name, [ExercismIO::ROOT, 'helpers', file].join('/')
    end
  end
end
