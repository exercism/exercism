require './lib/jobs/analyze'
require './lib/jobs/hello'
require './lib/exercism/rikki'

module ExercismAPI
  module Routes
    class Iterations < Core
      # Mark exercise as skipped.
      # Called from the CLI.
      post '/iterations/:track_id/:slug/skip' do |track_id, slug|
        require_key

        if current_user.guest?
          message = "Please double-check your exercism API key."
          halt 401, { error: message }.to_json
        end

        track = Trackler.tracks[track_id]

        unless track.exists?
          halt 400, { error: "Unknown language track %s" % track_id }.to_json
        end

        unless track.implementations[slug.to_s].exists?
          halt 400, { error: "Unknown problem '%s' in %s track" % [slug, track.language] }.to_json
        end

        attrs = {
          user_id: current_user.id,
          language: track_id,
          slug: slug,
        }

        exercise = UserExercise.where(attrs).first_or_initialize(iteration_count: 0)

        exercise.save! if exercise.new_record?
        exercise.touch(:skipped_at)
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

        unless user
          message = "unknown api key '#{data['key']}', "
          message << "please check http://exercism.io/account/key and reconfigure"
          halt 401, { error: message }.to_json
        end

        solution = data['solution']
        solution = { data['path'] => data['code'] } if solution.nil?

        # old CLI, let's see if we can hack around it.
        if data['language'].nil?
          path = data['path'] || solution.first.first
          path = path.gsub(/^\//, "")
          segments = path.split(/\\|\//)
          if segments.length < 3
            # nothing we can do.
            halt 400, "please upgrade your exercism command-line client"
          end
          data['language'] = segments[0].downcase
          data['problem'] = segments[1]
          data['path'] = segments[2..-1].join("/")
        end

        track = Trackler.tracks[data['language']]

        unless track.exists?
          halt 400, { error: "Unknown language track %s" % data['language'] }.to_json
        end

        unless track.implementations[data['problem'].to_s].exists?
          halt 400, { error: "Unknown problem '%s' in %s track" % [data['problem'], track.language] }.to_json
        end

        iteration = Iteration.new(
          solution,
          data['language'],
          data['problem'],
          comment: data['comment']
        )

        attempt = Attempt.new(user, iteration)

        if attempt.duplicate?
          halt 400, { error: "duplicate of previous iteration" }.to_json
        end

        attempt.save

        ACL.authorize(user, attempt.submission.problem)

        Notify.everyone(attempt.submission.reload, 'iteration', user)

        ConversationSubscription.join(user, attempt.submission)

        if attempt.slug == 'hello-world'
          Jobs::Hello.perform_async(attempt.submission.key, attempt.submission.version)
        elsif Rikki.supported_attempt?(attempt)
          Jobs::Analyze.perform_async(attempt.submission.key)
        end

        status 201
        locals = {
          submission: attempt.submission,
          domain: request.url.gsub(/#{request.path}$/, ""),
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

        pg :iterations, locals: { submissions: submissions }
      end
    end
  end
end
