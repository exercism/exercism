module ExercismWeb
  module Routes
    class Legacy < Core
      get '/nitpick/:language/?' do |language|
        redirect "/nitpick/#{language}/recent"
      end

      get '/user/submissions/:key' do |key|
        redirect "/submissions/#{key}"
      end

      get '/help/?*' do
        redirect "http://help.exercism.io"
      end
    end
  end
end
