module ExercismWeb
  module Routes
    class Legacy < Core
      get '/dashboard/:language/?' do |language|
        redirect "/nitpick/#{language}/no-nits"
      end

      get '/dashboard/:language/:slug/?' do |language, slug|
        redirect "/nitpick/#{language}/#{slug}"
      end

      get '/nitpick/:language/?' do |language|
        redirect "/nitpick/#{language}/no-nits"
      end

      get '/user/submissions/:key' do |key|
        redirect "/submissions/#{key}"
      end
    end
  end
end
