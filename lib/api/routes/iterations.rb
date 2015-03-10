require './lib/jobs/analyze'

module ExercismAPI
  module Routes
    class Iterations < Core
      get '/iterations/:key/restore' do |key|
        halt *Xapi.get("v2", "exercises", "restore", key: key)
      end

      post '/iterations/:language/:slug/skip' do |language, slug|
        require_key

        if current_user.guest?
          halt 401, {error: "Please double-check your exercism API key."}.to_json
        end

        exercise = UserExercise.where(user_id: current_user.id, language: language, slug: slug).first_or_initialize(iteration_count: 0, state: 'unstarted')
        if exercise.new_record?
          exercise.save!

          halt 204
        else
          message = "Exercise '#{slug}' in '#{language}' has already been "
          message += exercise.state == "unstarted" ? "skipped." : "started."

          halt 400, {error: message}.to_json
        end
      end

      post '/user/assignments' do
        request.body.rewind
        data = request.body.read
        if data.empty?
          halt 400, {error: "must send key and code as json"}.to_json
        end
        data = JSON.parse(data)
        user = User.where(key: data['key']).first
        begin
          LogEntry.create(user: user, key: data['key'], body: data.merge(user_agent: request.user_agent).to_json)
        rescue => e
          Bugsnag.notify(e)
          # ignore failures
        end
        unless user
          message = <<-MESSAGE
          unknown api key '#{data['key']}', please check your exercism.io account page and reconfigure
          MESSAGE
          halt 401, {error: message}.to_json
        end

        solution = data['solution']
        if solution.nil?
          solution = {data['path'] => data['code']}
        end

        attempt = Attempt.new(user, Iteration.new(solution))

        unless attempt.valid?
          Bugsnag.before_notify_callbacks << lambda { |notif|
            data = {
              user: user.username,
              code: data['code'],
              path: data['path'],
              track: attempt.track,
              slug: attempt.slug,
            }
            notif.add_tab(:data, data)
          }
          Bugsnag.notify(Attempt::InvalidAttemptError.new("Invalid attempt submitted"))
          error = "unknown problem (track: #{attempt.track}, slug: #{attempt.slug}, path: #{data['path']})"
          halt 400, {error: error}.to_json
        end

        if attempt.duplicate?
          halt 400, {error: "duplicate of previous iteration"}.to_json
        end

        attempt.save
        Notify.everyone(attempt.submission.reload, 'code', user)
        # if we don't have a 'fetched' event, we want to hack one in.
        LifecycleEvent.track('fetched', user.id)
        LifecycleEvent.track('submitted', user.id)
        # for now, let's just give rikki hamming exercises in Ruby.
        if attempt.track == 'ruby' && attempt.slug == 'hamming'
          Jobs::Analyze.perform_async(attempt.submission.key)
        end
        status 201
        pg :attempt, locals: {submission: attempt.submission, domain: request.url.gsub(/#{request.path}$/, "")}
      end

      delete '/user/assignments' do
        require_key

        if current_user.guest?
          halt 401, {error: "Please double-check your exercism API key."}.to_json
        end

        begin
          Unsubmit.new(current_user).unsubmit
        rescue Unsubmit::NothingToUnsubmit
          halt 404, {error: "Nothing to unsubmit."}.to_json
        rescue Unsubmit::SubmissionHasNits
          halt 403, {error: "The submission has nitpicks, so can't be deleted."}.to_json
        rescue Unsubmit::SubmissionDone
          halt 403, {error: "The submission has been already completed, so can't be deleted."}.to_json
        rescue Unsubmit::SubmissionTooOld
          halt 403, {error: "The submission is too old to be deleted."}.to_json
        end
        status 204
      end

      get '/iterations/latest' do
        require_key

        if current_user.guest?
          halt 401, {error: "Please double-check your exercism API key."}.to_json
        end

        submissions = current_user.exercises.order(:language, :slug).map {|exercise|
          exercise.submissions.last
        }.compact
        pg :iterations, locals: {submissions: submissions}
      end
    end
  end
end
