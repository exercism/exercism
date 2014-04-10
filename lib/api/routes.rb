module ExercismAPI
  module Routes
    {
      :Core => 'core',
      :Demo => 'demo',
      :Exercises => 'exercises',
      :Notifications => 'notifications',
      :Legacy => 'legacy',
    }.each do |name, file|
      autoload name, [ExercismAPI::ROOT, 'routes', file].join('/')
    end
  end
end
