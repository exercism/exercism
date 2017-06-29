module ExercismWeb
  module Routes
    class Static < Core
      get '/rikki-' do
        redirect '/rikki'
      end

      get '/rikki' do
        erb :"site/rikki"
      end

      get '/donate' do
        erb :"site/donate"
      end

      get '/help' do
        erb :"site/help", locals: { docs: X::Docs::Help.new }
      end

      get '/how-it-works' do
        erb :"site/how_it_works", locals: { docs: X::Docs::Intro.new }
      end

      get '/how-it-works/polyglot' do
        session[:target_profile] ||= 'polyglot'
        redirect '/how-it-works'
      end

      get '/how-it-works/artisan' do
        session[:target_profile] ||= 'artisan'
        redirect '/how-it-works'
      end

      get '/how-it-works/newbie' do
        session[:target_profile] ||= 'newbie'
        erb :"site/how_it_works_newbie"
      end

      %w(overview mac windows linux install).each do |topic|
        # Add OS detection logic & redirect here
        url_pattern = "/#{topic}" unless topic == 'overview'

        get "/clients/cli#{url_pattern}" do
          erb :"site/cli", locals: { docs: X::Docs::CLI.new, page: topic.to_sym }
        end
      end

      get '/privacy' do
        erb :"site/privacy"
      end

      get '/about' do
        erb :"site/about"
      end

      get '/bork' do
        fail RuntimeError.new("Hi Bugsnag, you're awesome!")
      end

      get '/no-such-page' do
        status 404
        erb :"errors/not_found"
      end

      get '/version' do
        erb :'site/version.json', layout: false
      end

      get '/contact' do
        erb :'site/contact'
      end

      get '/teams/about' do
        erb :'site/teams'
      end
    end
  end
end
