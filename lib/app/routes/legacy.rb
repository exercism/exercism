module ExercismWeb
  module Routes
    class Legacy < Core
      get '/:username/nitstats' do |username|
        redirect '/nits/%s/stats' % username
      end

      get '/nitpick/:language/?' do |language|
        redirect '/inbox'
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

      get '/nitpick/:language/:slug/?' do
        redirect '/inbox'
      end
    end
  end
end
