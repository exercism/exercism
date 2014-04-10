module ExercismAPI
  module Routes
    class Legacy < Core
      get '/assignments/demo' do
        Xapi.get("demo")
      end

      get '/assignments/:language/:slug' do |language, slug|
        Xapi.get("exercises", language, slug)
      end

      get '/user/assignments/current' do
        require_user
        Xapi.get("exercises", key: current_user.key)
      end

      get '/user/assignments/next' do
        halt 410, {error: "`peek` is deprecated. `fetch` always delivers the next exercise."}.to_json
      end

      get '/user/assignments/restore' do
        require_user
        Xapi.get("exercises", "restore", key: current_user.key)
      end

      post '/user/assignments' do
        request.body.rewind
        data = request.body.read
        if data.empty?
          halt 400, {:error => "Must send key and code as json."}.to_json
        end
        data = JSON.parse(data)
        user = User.where(key: data['key']).first
        begin
          LogEntry.create(user: user, body: data.merge(user_agent: request.user_agent).to_json)
        rescue => e
          # ignore failures
        end
        unless user
          message = <<-MESSAGE
      Please double-check the API key in your exercism account page and
      ensure you have logged into the CLI using the correct key.
          MESSAGE
          halt 401, {:error => message}.to_json
        end

        attempt = Attempt.new(user, data['code'], data['path'])

        unless attempt.valid?
          halt 400, {:error => "We are unable to determine which exercise you're submitting #{data['path']} to."}
        end

        if attempt.duplicate?
          halt 400, {:error => "This attempt is a duplicate of the previous one."}.to_json
        end

        attempt.save
        Notify.everyone(attempt.submission.reload, 'code', user)

        status 201
        pg :attempt, locals: {submission: attempt.submission}
      end

      delete '/user/assignments' do
        require_user
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

      get '/exercises' do
        require_user
        content_type 'application/json', :charset => 'utf-8'
        Homework.new(current_user).all.to_json
      end

      get '/iterations/latest' do
        require_user
        content_type 'application/json', :charset => 'utf-8'

        submissions = current_user.exercises.order(:language, :slug).map {|exercise|
          exercise.submissions.last
        }
        pg :iterations, locals: {submissions: submissions}
      end

      # Notification endpoints are only used in the prototype.
      # Delete when redesign launches.
      get '/notifications' do
        require_user
        notifications = current_user.notifications.on_submissions.recent
        alerts = current_user.alerts.map {|alert| Api::Notifications::Alert.new(alert) }
        pg :notifications, locals: {notifications: alerts + notifications}
      end

      # I think this should be
      # POST /notifications/:id/read
      put '/notifications/:id' do |id|
        require_user

        if id =~ /alert/
          notification = current_user.alerts.find(id.split('alert-').last)
        else
          notification = current_user.notifications.find(id)
        end

        notification.read!
        pg :notification, locals: {notification: notification}
      end

      get '/stats/:username/nitpicks/:year/:month' do |username, year, month|
        Api::Stats::NitStreak.for(username, year.to_i, month.to_i).to_json
      end

      get '/stats/:username/submissions/:year/:month' do |username, year, month|
        Api::Stats::SubmissionStreak.for(username, year.to_i, month.to_i).to_json
      end

      get '/stats/:username/snapshot' do |username|
        user = User.find_by_username(username)
        if !user
          halt 400, {error: "Unknown user #{username}"}
        end
        snapshot = Api::Stats::Snapshot.new(user)
        pg :"stats/snapshot", locals: {snapshot: snapshot}
      end
    end
  end
end
