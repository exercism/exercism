module ExercismIO
  module Routes
    class Exercises < Core
      get '/exercises/active' do
        haml :"exercises/index"
      end

      get '/exercises/completed' do
        haml :"exercises/index"
      end

      get '/exercises/:key' do |key|
        haml :"exercises/show"
      end
    end
  end
end
