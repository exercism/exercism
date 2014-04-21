module ExercismIO
  module Routes
    {
      :Core => 'core',
      :Static => 'static',
      :Help => 'help',
      :Account => 'account',
      :Session => 'session',
      :User => 'user',
      :Exercises => 'exercises',
      :Teams => 'teams',
      :GithubCallback => 'github_callback',
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('lib', 'redesign', 'routes', file)
    end
  end
end
