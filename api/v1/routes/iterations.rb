require './lib/jobs/analyze'
require './lib/jobs/hello'

module ExercismAPI
  module Routes
    class Iterations < Core
      # Mark exercise as skipped.
      # Called from the CLI.
      post '/iterations/:language/:slug/skip' do |language, slug|
        require_key

        if current_user.guest?
          message = "Please double-check your exercism API key."
          halt 401, { error: message }.to_json
        end

        if !Xapi.exists?(language, slug)
          message = "Exercise '#{slug}' in language '#{language}' doesn't exist. "
          message << "Maybe you mispelled it?"
          halt 404, { error: message }.to_json
        end

        exercise_attrs = {
          user_id: current_user.id,
          language: language,
          slug: slug
        }

        exercise = UserExercise.where(exercise_attrs)
          .first_or_initialize(iteration_count: 0)

        if exercise.new_record?
          exercise.save!
        end
        exercise.touch(:skipped_at)
        halt 204
      end

      # Mark exercise as fetched. Called from the X-API.
      post '/iterations/:language/:slug/fetch' do |language, slug|
        require_key
        if current_user.guest?
          message = 'Please double-check your exercism API key.'
          halt 401, { error: message }.to_json
        end
        unless Xapi.exists? language, slug
          message =
            "Exercise '#{slug}' in language '#{language}' doesn't exist. " \
            'Maybe you mispelled it?'
          halt 404, { error: message }.to_json
        end

        LifecycleEvent.track 'fetched', current_user.id
        attributes = { user_id: current_user.id,
                       language: language,
                       slug: slug }
        exercise = UserExercise.where(attributes).first_or_initialize
        # let's not bother tracking fetches for languages that you haven't
        # explicitly started.
        if current_user.submissions.where(language: language).count > 0
          exercise.fetched_at ||= Time.now.utc
        end
        exercise.iteration_count ||= 0
        exercise.save
        halt 204
      end

      # Submit an iteration.
      # Called from the CLI.
      post '/user/assignments' do
        request.body.rewind
        data = request.body.read

        if data.empty?
          halt 400, { error: "must send key and code as json" }.to_json
        end

        data = JSON.parse(data)
        user = User.where(key: data['key']).first

        begin
          log_entry_body = data.merge(user_agent: request.user_agent).to_json
          LogEntry.create(
            user: user,
            key: data['key'],
            body: log_entry_body
          )
        rescue => e
          Bugsnag.notify(e, nil, request)
          # ignore failures
        end

        unless user
          message = "unknown api key '#{data['key']}', "
          message << "please check http://exercism.io/account/key and reconfigure"
          halt 401, { error: message }.to_json
        end

        solution = data['solution']
        if solution.nil?
          solution = { data['path'] => data['code'] }
        end

        # old CLI, let's see if we can hack around it.
        if data['language'].nil?
          path = data['path'] || solution.first.first
          path = path.gsub(/^\//, "")
          segments = path.split(/\\|\//)
          if segments.length < 3
            # nothing we can do.
            halt 400, "please upgrade your exercism command-line client"
          end
          data['language'] = segments[0]
          data['problem'] = segments[1]
          data['path'] = segments[2..-1].join("/")
        end

        iteration = Iteration.new(
          solution,
          data['language'],
          data['problem'],
          comment: data['comment']
        )
        attempt = Attempt.new(user, iteration)

        unless attempt.valid?
          Bugsnag.before_notify_callbacks << lambda do |notif|
            data = {
              user: user.username,
              code: data['solution'],
              track: attempt.track,
              slug: attempt.slug,
            }
            notif.add_tab(:data, data)
          end

          error = Attempt::InvalidAttemptError.new("Invalid attempt submitted")
          Bugsnag.notify(error, nil, request)

          error = "unknown problem (track: #{attempt.track}, "
          error << "slug: #{attempt.slug}, path: #{data['path']})"
          halt 400, { error: error }.to_json
        end

        if attempt.duplicate?
          halt 400, { error: "duplicate of previous iteration" }.to_json
        end

        attempt.save

        ACL.authorize(user, attempt.submission.problem)

        Notify.everyone(attempt.submission.reload, 'iteration', user)

        # if we don't have a 'fetched' event, we want to hack one in.
        LifecycleEvent.track('fetched', user.id)
        LifecycleEvent.track('submitted', user.id)

        if (attempt.track == 'ruby' && attempt.slug == 'hamming') || attempt.track == 'go'
          Jobs::Analyze.perform_async(attempt.submission.key)
        end
        if attempt.slug == 'hello-world'
          Jobs::Hello.perform_async(attempt.submission.key, attempt.submission.version)
        end

        status 201
        locals = {
          submission: attempt.submission,
          domain: request.url.gsub(/#{request.path}$/, "")
        }
        pg :attempt, locals: locals
      end

      # Restore solutions.
      # Called from XAPI.
      get '/iterations/latest' do
        require_key

        if current_user.guest?
          message = "Please double-check your exercism API key."
          halt 401, { error: message }.to_json
        end

        exercises = current_user.exercises.order(:language, :slug)

        submissions = exercises.map { |e| e.submissions.last }.compact

        pg :iterations, locals: {submissions: submissions}
      end
    end
  end
end
