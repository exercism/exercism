module ExercismIO
  module Helpers
    {
      :URL => 'url',
      :Config => 'config',
      :Component => 'component',
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('lib', 'redesign', 'helpers', file)
    end
  end
end
