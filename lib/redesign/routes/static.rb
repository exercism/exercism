module ExercismIO
  module Routes
    class Static < Core
      get '/about' do
        haml :"static/about"
      end

      get '/getting-started' do
        haml :"static/getting-started"
      end
    end
  end
end
