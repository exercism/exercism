module ExercismIO
  module Routes
    class Help < Core
      get '/' do
        haml :"help/index"
      end
    end
  end
end
