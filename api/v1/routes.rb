module ExercismAPI
  module Routes
    {
      Core: 'core',
      Exercises: 'exercises',
      Iterations: 'iterations',
      Submissions: 'submissions',
      Comments: 'comments',
      Users: 'users',
      Legacy: 'legacy',
      Tracks: 'tracks',
      Stats: 'stats',
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('api', 'v1', 'routes', file)
    end
  end
end
