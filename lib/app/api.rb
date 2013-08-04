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
      halt 400, "Must send key and code as json."
    end
    data = JSON.parse(data)
    user = User.find_by(key: data['key'])
    halt 401, "Unable to identify user" unless user

    attempt = Attempt.new(user, data['code'], data['path']).save
    Notify.everyone(attempt.previous_submission, user, 'new_attempt')

    status 201
    pg :attempt, locals: {submission: attempt.submission}
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
