class ExercismAPI < Sinatra::Base
  get '/assignments/demo' do
    assignments = Exercism.trails.map do |trail|
      trail.first_assignment
    end
    pg :assignments, locals: {assignments: assignments}
  end

  get '/user/assignments/completed' do
    require_user
    {assignments: current_user.completed}.to_json
  end

  get '/user/assignments/current' do
    require_user
    assignments = Assignments.new(current_user.key)
    pg :assignments, locals: {assignments: assignments.current}
  end

  post '/user/assignments' do
    request.body.rewind
    data = request.body.read
    if data.empty?
      halt 400, {:error => "Must send key and code as json."}.to_json
    end
    data = JSON.parse(data)
    user = User.where(key: data['key']).first
    unless user
      message = <<-MESSAGE
      Beloved user,

      We have changed your API key (and everyone else's).

      You will need to log out from the exercism command line client
      (`exercism logout`) and log back in using the new API key in
      your account on the website.

      Sorry about the inconvenience!
      MESSAGE
      halt 401, {:error => message}.to_json
    end

    begin
      attempt = Attempt.new(user, data['code'], data['path'])
      # TODO: refactor to ask about validity
      attempt.exercise
      attempt.validate!
    rescue Exercism::UnavailableExercise, Exercism::UnknownExercise, Exercism::UnknownLanguage => e
      halt 400, {:error => e.message}.to_json
    end

    if attempt.duplicate?
      halt 400, {:error => "This attempt is a duplicate of the previous one."}.to_json
    end

    attempt.save
    Notify.everyone(attempt.previous_submission, 'code', except: user)

    if upgrade_gem?(request.user_agent)
      Notify.about("Please update your exercism gem, as there have been some significant improvements.", to: attempt.submission.user)
    end

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

  get '/user/assignments/next' do
    require_user
    assignments = Assignments.new(current_user.key).next

    halt 404, 'No more assignments!' if assignments.empty?

    pg :assignments, locals: {assignments: assignments}
  end
end

