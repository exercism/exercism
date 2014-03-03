module ExercismIO
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, './lib/redesign'
      end

      helpers ExercismIO::Helpers::URL
    end
  end
end
