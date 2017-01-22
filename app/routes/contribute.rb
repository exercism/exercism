module ExercismWeb
  module Routes
    class Contribute < Core
      get '/contribute' do
        erb :"contribute/index"
      end
    end
  end
end
