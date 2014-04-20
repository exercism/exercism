module ExercismIO
  module Routes
    class Core < Sinatra::Application
      APP_ROOT = File.expand_path(File.join(__FILE__, '..', '..'))

      configure do
        set :root, APP_ROOT
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
