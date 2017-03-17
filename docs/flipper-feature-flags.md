Feature Flags
=============

Feature flags allow specific features to be turned on and off at runtime for a
percentage of users or the entire site. Feature flags enable:

- Testing out new features on a limited portion of our users
- Quick rollback when we discover a problem in production

We use the [Flipper][1] library for feature flags. This document covers its basic
usage in Exercism, but see its [documentation][1] for more.

Process
-------

1. Surround the new feature's code with a conditional:

    ```ruby
    if $flipper[:a_name_for_your_feature].enabled?(current_user)
      # do the new thing
    else
      # do the old thing, or maybe nothing
    end
    ```

2. In development, enable the feature in the UI (http://localhost:4567/flipper/)
3. Get your feature deployed, ensuring you mention the feature flag in the Pull
   Request. Ask a flipper admin (@kytrinyx) to enable your feature.
4. Create an issue for the removal of the feature flag, to ensure it isn't forgotten.
5. Ensure everything is tested and working in production for a reasonable amount of
   time.
6. **Important**: Create a new pull request that removes all your feature flipper's
   conditionals, removing any old code the new feature replaced and all references to
   your feature flag. Leaving enabled feature flags in the code increases complexity
   and is unacceptable. The feature flag admin will delete the feature flag in the UI
   after the PR is merged and deployed successfully.

   [1]: https://github.com/jnunemaker/flipper
