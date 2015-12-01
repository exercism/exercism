require_relative '../../x'

module ExercismWeb
  module Routes
    class Metadata < Core
      get '/exercises/:id/:slug/tests' do |track_id, slug|
        _, response = X::Problem.test_files(track_id, slug)
        erb :"exercises/test_suite", locals: {problem: response['exercise']}
      end

      get '/exercises/:id/:slug/readme' do |track_id, slug|
        _, response = X::Problem.readme(track_id, slug)
        erb :"exercises/readme", locals: {problem: response['exercise']}
      end
    end
  end
end
