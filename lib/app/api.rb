class ExercismApp < Sinatra::Base

  get '/api/v1/user/assignments/current' do
    unless params[:key]
      halt 401, {error: "Please provide API key"}.to_json
    end

    assignments = Assignments.new(params[:key])

    data = assignments.current.map do |assignment|
      {
        track: assignment.language,
        slug: assignment.slug,
        readme: assignment.readme,
        test_file: assignment.test_file,
        tests: assignment.tests
      }
    end
    {assignments: data}.to_json
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

    result = {
      status: "saved",
      language: attempt.submission.language,
      exercise: attempt.submission.slug
    }
    halt 201, result.to_json
  end

  get '/api/v1/user/assignments/next' do
    unless params[:key]
      halt 401, {error: "Please provide API key"}.to_json
    end

    assignments = Assignments.new(params[:key])

    data = assignments.next.map do |assignment|
      {
        track: assignment.language,
        slug: assignment.slug,
        readme: assignment.readme,
        test_file: assignment.test_file,
        tests: assignment.tests
      }
    end
    {assignments: data}.to_json
  end
end
