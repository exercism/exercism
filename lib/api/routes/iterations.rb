module ExercismAPI
  module Routes
    class Iterations < Core
      post '/user/assignments' do
        request.body.rewind
        data = request.body.read
        if data.empty?
          halt 400, {error: "Must send key and code as json."}.to_json
        end
        data = JSON.parse(data)
        user = User.where(key: data['key']).first
        begin
          LogEntry.create(user: user, body: data.merge(user_agent: request.user_agent).to_json)
        rescue => e
          Bugsnag.notify(e)
          # ignore failures
        end
        unless user
          message = <<-MESSAGE
      Please double-check the API key in your exercism account page and
      ensure you have logged into the CLI using the correct key.
          MESSAGE
          halt 401, {error: message}.to_json
        end

        attempt = Attempt.new(user, data['code'], data['path'])

        unless attempt.valid?
          halt 400, {error: "We are unable to determine which exercise you're submitting #{data['path']} to."}.to_json
        end

        if attempt.duplicate?
          halt 400, {error: "This attempt is a duplicate of the previous one."}.to_json
        end

        attempt.save
        Notify.everyone(attempt.submission.reload, 'code', user)
        LifecycleEvent.track('submitted', user.id)
        status 201
        pg :attempt, locals: {submission: attempt.submission}
      end

      delete '/user/assignments' do
        require_key
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

        submissions = current_user.exercises.order(:language, :slug).map {|exercise|
          exercise.submissions.last
        }.compact
        pg :iterations, locals: {submissions: submissions}
      end
    end
  end
end
