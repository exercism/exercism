module ExercismAPI
  module Routes
    class Core < Sinatra::Application
      ERR_PLEASE_UPGRADE = "Please upgrade to the most recent version of the command-line client.".freeze

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

      unless settings.test?
        error 500 do
          Bugsnag.auto_notify($ERROR_INFO)
          { error: "Sorry, something went wrong. We've been notified and will look into it." }.to_json
        end
      end

      before do
        content_type 'application/json', charset: 'utf-8'
      end

      before do
        cache_control :private
      end

      helpers do
        def require_key
          if params[:key].to_s.empty?
            halt 401, { error: "You must be logged in to access this feature. Please double-check your API key." }.to_json
          end
        end

        def current_user
          @current_user ||= find_user || Guest.new
        end

        def find_user
          User.where(key: params[:key]).first if params[:key]
        end
      end
    end
  end
end
