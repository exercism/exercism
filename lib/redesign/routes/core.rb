module ExercismIO
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, './lib/redesign'
      end

      helpers ExercismIO::Helpers::Config
      helpers ExercismIO::Helpers::Session
      helpers ExercismIO::Helpers::URL
      helpers ExercismIO::Helpers::Article
      helpers ExercismIO::Helpers::Component
      helpers ExercismIO::Helpers::FuzzyTime
    end
  end
end
