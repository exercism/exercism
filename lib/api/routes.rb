module ExercismAPI
  module Routes
    {
      :Core => 'core',
      :Legacy => 'legacy',
    }.each do |name, file|
      autoload name, [ExercismAPI::ROOT, 'routes', file].join('/')
    end
  end
end
