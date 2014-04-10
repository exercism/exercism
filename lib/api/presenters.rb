module ExercismAPI
  module Presenters
    {
      :Alert => 'alert',
    }.each do |name, file|
      autoload name, [ExercismAPI::ROOT, 'presenters', file].join('/')
    end
  end
end
