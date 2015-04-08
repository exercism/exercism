# Staging Environment

This is a log of what I did in order to set up the staging environment.
It's a work in progress, and mostly just a "note to self" type thing.

Create the app:

```
heroku apps:create --app exercism-theory
git remote add theory git@heroku.com:exercism-theory.git
git push -f theory master
```

Add a couple of necessary addons:

```
heroku addons:add heroku-postgresql --app exercism-theory
heroku addons:add redistogo --app exercism-theory
```

Set some config vars:

```
heroku config:set --app exercism-theory EXERCISM_GITHUB_CLIENT_ID=abc123
heroku config:set --app exercism-theory EXERCISM_GITHUB_CLIENT_SECRET=abcdefg123456
heroku config:set --app exercism-theory RACK_ENV=production
```

Add a pre-push commit hook `.git/hooks/pre-push`:

```
#!/bin/bash

remote="$1"

if [[ $remote =~ theory ]]
then
        hash=$(git log -1 --format="%h")
        heroku config:set BUILD_ID=$hash
fi
exit 0
```

Migrate the database:

```
heroku run --app exercism-theory rake db:migrate
```
