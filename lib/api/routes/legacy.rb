module ExercismAPI
  module Routes
    class Legacy < Core
      get '/assignments/demo' do
        redirect '/api/v1/demo'
      end

      get '/assignments/:language' do |language|
        redirect "/api/v1/exercises/#{language}"
      end

      get '/assignments/:language/:slug' do |language, slug|
        redirect "/api/v1/exercises/#{language}/#{slug}"
      end

      get '/user/assignments/current' do
        unless params[:key]
          halt 401, {error: "API key is required. Please log in."}.to_json
        end
        if current_user.guest?
          halt 401, {error: "Please double-check your API key in your account page."}.to_json
        end
        halt *Xapi.get("exercises", key: params[:key])
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
