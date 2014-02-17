require 'api/assignments/demo'
require 'api/assignments/fetch'
require 'api/assignments/restore'

class ExercismAPI < Sinatra::Base
  helpers do
    def curriculum
      Exercism.curriculum
    end
  end

  get '/assignments/demo' do
    demo = API::Assignments::Demo.new(curriculum)
    pg :assignments, locals: {assignments: demo.assignments}
  end

  get '/assignments/:language/:slug' do |language, slug|
    unless curriculum.available?(language)
      halt 400, {error: "Sorry, we don't have exercises in '#{language}'."}.to_json
    end

    trail = curriculum.in(language)
    exercise = trail.find(slug)
    unless exercise
      halt 400, {error: "Sorry, we don't have '#{slug}' in '#{language}'."}.to_json
    end

    # Is it gross to return an array?
    pg :assignments, locals: {assignments: [trail.assign(slug)]}
  end

  get '/user/assignments/completed' do
    require_user
    {assignments: current_user.completed}.to_json
  end

  get '/user/assignments/current' do
    require_user
    sql = "SELECT language, slug FROM submissions WHERE user_id = %s AND state='done'" % current_user.id.to_s
    completed = Submission.connection.execute(sql).map {|result| [result["language"], result["slug"]]}
    sql = "SELECT language, slug FROM submissions WHERE user_id = %s AND (state='pending' OR state='hibernating')" % current_user.id.to_s
    current = Submission.connection.execute(sql).map {|result| [result["language"], result["slug"]]}

    handler = API::Assignments::Fetch.new(completed, current, curriculum)
    pg :assignments, locals: {assignments: handler.assignments}
  end

  get '/user/assignments/next' do
    halt 410, {error: "`peek` is deprecated. `fetch` always delivers the next exercise."}.to_json
  end

  get '/user/assignments/restore' do
    require_user
    sql = "SELECT u.language, u.slug, s.code, s.filename FROM user_exercises u, submissions s WHERE u.id = s.user_exercise_id AND u.state = s.state AND u.state IN ('done', 'pending', 'hibernating') AND u.user_id = %s" % current_user.id.to_s
    submitted = Submission.connection.execute(sql).map {|result| [result["language"], result["slug"], result["code"], result["filename"]]}
    handler = API::Assignments::Restore.new(submitted, curriculum)
    pg :assignments_compact, locals: {assignments: handler.assignments}
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
    rescue Exercism::UnknownExercise, Exercism::UnknownLanguage => e
      halt 400, {:error => e.message}.to_json
    end

    if attempt.duplicate?
      halt 400, {:error => "This attempt is a duplicate of the previous one."}.to_json
    end

    attempt.save
    Notify.everyone(attempt.submission.reload, 'code', except: user)

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

end

