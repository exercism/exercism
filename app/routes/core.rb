module ExercismWeb
  module Routes
    class Core < Sinatra::Application
      configure do
        set :public_folder, Exercism.relative_to_root('public')
        set :root, Exercism.relative_to_root('app')
        set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
        set :method_override, true

        enable :raise_errors
      end

      configure :production do
        disable :show_exceptions
      end

      configure :development, :test do
        # Comment out this line if you want
        # to see the gorgeous 500 page
        enable :show_exceptions
      end

      unless settings.test?
        error 500 do
          metadata = {
            user: {
            id: current_user.id,
            username: current_user.username,
          },
          context: request.path_info,
          app: {
            version: BUILD_ID,
          },
          }
          notification = Bugsnag.auto_notify($ERROR_INFO, metadata, request)
          erb :"errors/internal", locals: { bugsnag_notification: notification }
        end
      end

      before do
        cache_control :private
      end

      use Rack::Flash

      helpers Helpers::NotificationCount # total hack
      helpers Helpers::FuzzyTime
      helpers Helpers::NgEsc
      helpers Helpers::Markdown
      helpers Helpers::Syntax
      helpers Helpers::Session
      helpers Helpers::Gravatar
      helpers Helpers::Profile
      helpers Helpers::Submission
      helpers Helpers::SiteTitle
      helpers Helpers::TrackImage
      helpers Helpers::UserProgressBar
      helpers Helpers::TeamAccess
      helpers WillPaginate::Sinatra::Helpers
      helpers Helpers::CssUrl

      helpers do
        def github_client_id
          ENV.fetch('EXERCISM_GITHUB_CLIENT_ID')
        end

        def github_client_secret
          ENV.fetch('EXERCISM_GITHUB_CLIENT_SECRET')
        end

        def host
          request.host_with_port + root_path
        end

        def site_root
          host
        end

        def root_path
          '/'
        end

        def h(value)
          Rack::Utils.escape_html value
        end

        def link_to(path)
          File.join(root_path, path)
        end

        def assumable_users
          AssumableUser.all
        end

        def nav_text(slug)
          slug.split("-").map(&:capitalize).join(" ")
        end

        def namify(slug)
          slug.to_s.split('-').map(&:capitalize).join('-')
        end

        def css_url
          @css_url || "/css/application.css?t=#{File.mtime('./public/css/application.css').to_i}"
        end
      end
    end
  end
end
