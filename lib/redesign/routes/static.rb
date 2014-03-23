module ExercismIO
  module Routes
    class Static < Core
      get '/about' do
        haml :"static/about"
      end

      get '/getting-started' do
        haml :"static/getting-started"
      end

      get '/blog' do
        haml :"static/blog"
      end
    end
  end
end
