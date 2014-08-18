module ExercismAPI
  module Routes
    class Legacy < Core
      get '/assignments/demo' do
        redirect '/api/v1/demo'
      end

      get '/assignments/:track_id' do |track_id|
        redirect "/api/v1/exercises/#{track_id}?key=#{params[:key]}"
      end

      get '/assignments/:track_id/:slug' do |track_id, slug|
        redirect "/api/v1/exercises/#{track_id}/#{slug}"
      end

      get '/user/assignments/current' do
        unless params[:key]
          halt 401, {error: "API key is required. Please log in."}.to_json
        end
        if current_user.guest?
          halt 401, {error: "Please double-check your API key in your account page."}.to_json
        end
        status, data = Xapi.get("exercises", key: params[:key])
        LifecycleEvent.track('fetched', current_user.id)
        halt status, data
      end

      get '/user/assignments/restore' do
        halt *Xapi.get("exercises", "restore", key: params[:key])
      end

      get '/user/assignments/next' do
        halt 410, {error: "`peek` is deprecated. `fetch` always delivers the next exercise."}.to_json
      end
    end
  end
end
