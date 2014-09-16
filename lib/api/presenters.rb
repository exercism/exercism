module ExercismAPI
  module Presenters
    {
      Looks: 'looks',
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('lib', 'api', 'presenters', file)
    end
  end
end
