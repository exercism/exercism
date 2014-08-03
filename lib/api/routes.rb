module ExercismAPI
  module Routes
    {
      Core: 'core',
      Demo: 'demo',
      Exercises: 'exercises',
      Iterations: 'iterations',
      Submissions: 'submissions',
      Comments: 'comments',
      Stats: 'stats',
      Users: 'users',
      Legacy: 'legacy',
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('lib', 'api', 'routes', file)
    end
  end
end
