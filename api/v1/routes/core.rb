module ExercismAPI
  module Routes
    class Core < Sinatra::Application
     ErrPleaseUpgrade = "Please upgrade to the most recent version of the command-line client."

      configure do
        set :root, ExercismAPI::ROOT
        enable :raise_errors
      end

      configure :production do
        disable :show_exceptions
      end

      configure :development do
        enable :show_exceptions
      end

      error 500 do
        Bugsnag.auto_notify($!)
        {error: "Sorry, something went wrong. We've been notified and will look into it."}.to_json
      end

      before do
        content_type 'application/json', charset: 'utf-8'
      end

      before do
        cache_control :private
      end

      helpers do
        def require_key
          unless params[:key]
            halt 401, {error: "You must be logged in to access this feature. Please double-check your API key."}.to_json
          end
        end

        def current_user
          @current_user ||= find_user || Guest.new
        end

        def find_user
          if params[:key]
            User.where(key: params[:key]).first
          end
        end
      end
    end
  end
end
