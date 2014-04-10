require 'redesign/helpers/fuzzy_time'

module ExercismAPI
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, ['.', 'lib', ExercismAPI::ROOT].join('/')
      end

      before do
        content_type 'application/json', :charset => 'utf-8'
      end

      helpers ExercismIO::Helpers::FuzzyTime

      helpers do
        def require_user
          if current_user.guest?
            halt 401, {error: "You must be logged in to access this feature. Please double-check your API key."}.to_json
          end
        end

        def current_user
          @current_user ||= find_user || Guest.new
        end

        def find_user
          if session[:github_id]
            User.where(github_id: session[:github_id]).first
          elsif params[:key]
            User.where(key: params[:key]).first
          end
        end
      end
    end
  end
end
