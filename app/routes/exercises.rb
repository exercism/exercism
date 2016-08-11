module ExercismWeb
  module Routes
    class Exercises < Core
      get '/exercises/:track_id/:slug/test-suite' do |id, slug|
        status, body = X::Xapi.get('tracks', id, 'exercises', slug, 'tests')
        if status > 299
          flash[:notice] = JSON.parse(body)["error"]
          redirect '/'
        end

        exercise = X::Exercise.new(JSON.parse(body)['exercise'])
        erb :"exercises/test_suite", locals: { exercise: exercise }
      end

      get '/exercises/:track_id/:slug/readme' do |id, slug|
        status, body = X::Xapi.get('tracks', id, 'exercises', slug, 'readme')
        if status > 299
          flash[:notice] = JSON.parse(body)["error"]
          redirect '/'
        end

        exercise = X::Exercise.new(JSON.parse(body)['exercise'])
        erb :"exercises/readme", locals: { exercise: exercise }
      end

      get '/exercises/:track_id/:slug' do |id, slug|
        redirect "/exercises/#{id}/#{slug}/readme"
      end
    end
  end
end
