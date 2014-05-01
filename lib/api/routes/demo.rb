module ExercismAPI
  module Routes
    class Demo < Core
      get '/demo' do
        halt *Xapi.get("demo")
      end
    end
  end
end
