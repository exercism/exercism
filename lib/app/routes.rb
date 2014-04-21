module ExercismWeb
  module Routes
    {
      :Core => 'core',
      :Legacy => 'legacy',
      :Stats => 'stats',
      :Static => 'static',
      :Help => 'help',
      :Account => 'account',
      :Backdoor => 'backdoor',
      :Sessions => 'sessions',
      :Looks => 'looks',
      :Solutions => 'solutions',
      :Comments => 'comments',
      :Exercises => 'exercises',
      :Metadata => 'metadata',
      :Teams => 'teams',
      :User => 'user',
      :Errors => 'errors',
    }.each do |name, file|
      autoload name, ['app', 'routes', file].join('/')
    end
  end
end
