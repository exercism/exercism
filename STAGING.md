# Staging Environment

## Testing Stuff

To configure the client to use the staging environment for submitting solutions,
use the following command:

    exercism configure --key=abc --host=http://exercism-theory.herokuapp.com --api=http://x.exercism.io

You can also use a local copy of the x-api if you have specific problems you're testing there.
Or we can add exercism-xapi-theory as well.

## Deploying a branch to staging

If you have a branch that you want to test on staging, you can push that branch
to the remote master:

    git push -f heroku my-branch:master

## TODO

We may want to tweak the app so we can set RACK_ENV=staging and perhaps have a
specific header or different website colour (or at the very least a different
favicon colour), just so that we don't accidentally go to staging thinking it's
production.

We may want to add seed data in staging; It downloads some flat files, which I'm
not sure we can do. We'd have to try it.

## Creating the staging environment

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
