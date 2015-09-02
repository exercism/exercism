module ExercismWeb
  module Routes
    class Legacy < Core
      get '/:username/nitstats' do |username|
        redirect '/nits/%s/stats' % username
      end

      get '/nitpick/:language/?' do |language|
        redirect "/nitpick/#{language}/recent"
      end

      get '/user/submissions/:key' do |key|
        redirect "/submissions/#{key}"
      end

      get '/help/?*' do
        redirect "http://help.exercism.io"
      end

      get '/setup/?*' do
        redirect "http://help.exercism.io"
      end

      # This is the 'pending' list.
      # To be replaced with the inbox at GET /exercises/:track_id.
      get '/nitpick/:language/:slug/?' do |track_id, slug|
        please_login

        workload = Workload.new(current_user, track_id, slug || 'recent')

        locals = {
          submissions: workload.submissions,
          language: workload.track_id,
          exercise: workload.slug,
          exercises: workload.available_exercises,
          breakdown: workload.breakdown
        }
        erb :"nitpick/index", locals: locals
      end
    end
  end
end
