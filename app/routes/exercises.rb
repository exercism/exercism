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

      get '/exercises/:track_id/:slug/readme' do |track_id, slug|
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

        erb :"exercises/readme", locals: {
          track: track,
          implementation: implementation,
        }
      end

      get '/exercises/:track_id/:slug' do |id, slug|
        redirect "/exercises/#{id}/#{slug}/readme"
      end
    end
  end
end
