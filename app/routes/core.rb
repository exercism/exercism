module ExercismWeb
  module Routes
    # rubocop:disable Metrics/ClassLength
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

      error 500 do
        metadata = {
          user: {
            id: current_user.id,
            username: current_user.username,
          },
          context: request.path_info,
          app: {
            version: ENV["BUILD_ID"] || "unknown",
          },
        }
        Bugsnag.auto_notify($ERROR_INFO, metadata, request)
        erb :"errors/internal"
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
      helpers WillPaginate::Sinatra::Helpers

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

        def path_for(language=nil, section='nitpick')
          if language
            "/#{section}/#{language.downcase}"
          else
            "/"
          end
        end

        def language_path_for_slug(language, slug)
          path_for(language) + "/#{slug}"
        end

        def assumable_users
          AssumableUser.all
        end

        def active_nav(path)
          if path == request.path_info
            "active"
          else
            ""
          end
        end

        def nav_text(slug)
          slug.split("-").map(&:capitalize).join(" ")
        end

        def dashboard_assignment_section_nav(language, slug)
          path = language_path_for_slug(language, slug)
          %(<li class="#{active_nav(path)}">
          <a href="#{path}">#{nav_text(slug)}</a>
        </li>)
        end

        def dashboard_assignment_nav(language, slug=nil, counts=nil)
          return if !counts || counts.zero?

          path = language_path_for_slug(language, slug)
          %{<li class="#{active_nav(path)}">
          <a href="#{path}">#{nav_text(slug)} (#{counts})</a>
        </li>}
        end

        def namify(slug)
          slug.to_s.split('-').map(&:capitalize).join('-')
        end

        def tracks
          ExercismWeb::Presenters::Tracks.tracks
        end

        def css_url
          @css_url || "/css/application.css?t=#{File.mtime('./public/css/application.css').to_i}"
        end
      end
    end
  end
end
