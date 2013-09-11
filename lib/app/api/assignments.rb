class ExercismApp < Sinatra::Base

  get '/api/v1/assignments/demo' do
    assignments = Exercism.trails.map do |trail|
      trail.first_assignment
    end
    pg :assignments, locals: {assignments: assignments}
  end

  get '/api/v1/user/assignments/completed' do
    unless params[:key]
      halt 401, {error: "Please provide API key"}.to_json
    end

    assignments = Assignments.new(params[:key])

    {assignments: assignments.completed}.to_json
  end

  get '/api/v1/user/assignments/current' do
    unless params[:key]
      halt 401, {error: "Please provide API key"}.to_json
    end

    assignments = Assignments.new(params[:key])

    pg :assignments, locals: {assignments: assignments.current}
  end

  post '/api/v1/user/assignments' do
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

      You will need to log out from the exercism gem (`exercism logout`)
      and log back in using the new API key in your account on the website.

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

  delete '/api/v1/user/assignments' do
    unless params[:key]
      halt 401, {error: "Please provide API key"}.to_json
    end
    user = User.find_by(key: params[:key])
    begin
      Unsubmit.new(user).unsubmit
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

  get '/api/v1/user/assignments/next' do
    unless params[:key]
      halt 401, {error: "Please provide API key"}.to_json
    end

    assignments = Assignments.new(params[:key]).next

    halt 404, 'No more assignments!' if assignments.empty?

    pg :assignments, locals: {assignments: assignments}
  end
end
