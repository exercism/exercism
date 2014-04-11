module ExercismWeb
  module Routes
    {
      :Core => 'core',
      :Legacy => 'legacy',
    }.each do |name, file|
      autoload name, ['app', 'routes', file].join('/')
    end
  end
end
