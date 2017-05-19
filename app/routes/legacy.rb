module ExercismWeb
  module Routes
    class Legacy < Core
      get '/nitpick/:language/?' do
        redirect '/inbox'
      end

      get '/user/submissions/:key' do |key|
        redirect "/submissions/#{key}"
      end

      get '/setup/?*' do
        redirect "/help"
      end

      get '/nitpick/:language/:slug/?' do
        redirect '/inbox'
      end
    end
  end
end
