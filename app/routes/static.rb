module ExercismWeb
  module Routes
    class Static < Core
      get '/rikki' do
        erb :"site/rikki"
      end

      get '/donate' do
        erb :"site/donate"
      end

      get '/help' do
        erb :"site/help", locals: {docs: X::Docs::Help.new}
      end

      get '/privacy' do
        erb :"site/privacy"
      end

      get '/about' do
        erb :"site/about", locals: {active_languages: ExercismWeb::Presenters::Languages.new(tracks.select(&:active?).map(&:language)).to_s,
                                    upcoming_languages: ExercismWeb::Presenters::Languages.new(tracks.select(&:upcoming?).map(&:language)).to_s,
                                    planned_languages: ExercismWeb::Presenters::Languages.new(tracks.select(&:planned?).map(&:language)).to_s}
      end

      get '/getting-started' do
        erb :"site/getting-started", locals: {active_languages: ExercismWeb::Presenters::Languages.new(tracks.select(&:active?).map(&:language)).to_s}
      end

      get '/bork' do
        raise RuntimeError.new("Hi Bugsnag, you're awesome!")
      end

      get '/no-such-page' do
        status 404
        erb :"errors/not_found"
      end
    end
  end
end
