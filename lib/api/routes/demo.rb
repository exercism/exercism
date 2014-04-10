module ExercismAPI
  module Routes
    class Demo < Core
      get '/demo' do
        Xapi.get("demo")
      end
    end
  end
end
