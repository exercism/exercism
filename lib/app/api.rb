class ExercismApp < Sinatra::Base

  helpers do
    def require_key
      unless params[:key]
        halt 401, {error: "Please provide API key"}.to_json
      end
    end
  end

  get '/api/v1/user/assignments/current' do
    require_key

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

end
