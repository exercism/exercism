module ExercismIO
  module Routes
    class Home < Core
      get '/' do
        haml :"home/index"
      end
    end
  end
end
