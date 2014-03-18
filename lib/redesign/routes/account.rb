module ExercismIO
  module Routes
    class Account < Core
      get '/account' do
        haml :"account/index"
      end
    end
  end
end
