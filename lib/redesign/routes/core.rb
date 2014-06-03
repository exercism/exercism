module ExercismIO
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, Exercism.relative_to_root('lib', 'redesign')
      end

      helpers ExercismIO::Helpers::Config
      helpers ExercismWeb::Helpers::Session
      helpers ExercismIO::Helpers::URL
      helpers ExercismIO::Helpers::Component
      helpers ExercismWeb::Helpers::FuzzyTime
    end
  end
end
