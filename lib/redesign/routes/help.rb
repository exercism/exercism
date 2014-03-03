module ExercismIO
  module Routes
    class Help < Core
      get '/help' do
        haml :"help/index"
      end
    end
  end
end
