module ExercismWeb
  module Routes
    {
      Core: 'core',
      Inbox: 'inbox',
      Languages: 'languages',
      Legacy: 'legacy',
      Main: 'main',
      OnboardingSteps: 'onboarding_steps',
      Stats: 'stats',
      Static: 'static',
      Conversations: 'conversations',
      Account: 'account',
      Backdoor: 'backdoor',
      Sessions: 'sessions',
      Notifications: 'notifications',
      Looks: 'looks',
      Solutions: 'solutions',
      Comments: 'comments',
      Exercises: 'exercises',
      Submissions: 'submissions',
      Metadata: 'metadata',
      Teams: 'teams',
      Tracks: 'tracks',
      Styleguide: 'styleguide',
      CommentThreads: 'comment_threads',
      Errors: 'errors',
      User: 'user',
      GithubCallback: 'github_callback'
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('app', 'routes', file)
    end
  end
end
