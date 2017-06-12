module ExercismWeb
  module Routes
    {
      Core: 'core',
      Inbox: 'inbox',
      Languages: 'languages',
      Legacy: 'legacy',
      Main: 'main',
      Stats: 'stats',
      Static: 'static',
      Contribute: 'contribute',
      Account: 'account',
      Backdoor: 'backdoor',
      Sessions: 'sessions',
      Notifications: 'notifications',
      Looks: 'looks',
      Solutions: 'solutions',
      Comments: 'comments',
      Exercises: 'exercises',
      UserExercises: 'user_exercises',
      Submissions: 'submissions',
      Tags: 'tags',
      Teams: 'teams',
      Invitations: 'invitations',
      Requests: 'requests',
      Tracks: 'tracks',
      Styleguide: 'styleguide',
      Subscriptions: 'subscriptions',
      Errors: 'errors',
      User: 'user',
      GitHubCallback: 'github_callback',
      Profile: 'profile',
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('app', 'routes', file)
    end
  end
end
