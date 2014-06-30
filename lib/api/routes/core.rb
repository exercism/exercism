module ExercismAPI
  module Routes
    class Core < Sinatra::Application
      use Bugsnag::Rack

      configure do
        set :root, ExercismAPI::ROOT
      end

      before do
        content_type 'application/json', :charset => 'utf-8'
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
