module ExercismWeb
  module Routes
    class Exercises < Core
      get '/exercises/:track_id/:slug/test-suite' do |track_id, slug|
        track = Trackler.tracks[track_id]
        unless track.exists?
          status 404
          erb :"errors/not_found"
        end

        implementation = track.implementations[slug]
        unless implementation.exists?
          status 404
          erb :"errors/not_found"
        end

        erb :"exercises/test_suite", locals: {
          track: track,
          implementation: implementation,
        }
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
