module ExercismWeb
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, Exercism.relative_to_root('lib', 'app')
        set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
        set :method_override, true

        enable :raise_errors
      end

      configure :production do
        disable :show_exceptions
      end

      configure :development do
        # Comment out this line if you want
        # to see the gorgeous 500 page
        enable :show_exceptions
      end

      error 500 do
        Bugsnag.auto_notify($!)
        erb :"errors/internal"
      end

      use Rack::Flash

      helpers Helpers::NotificationCount # total hack
      helpers Helpers::FuzzyTime
      helpers Helpers::NgEsc
      helpers Helpers::Markdown
      helpers Helpers::Session
      helpers WillPaginate::Sinatra::Helpers
      helpers Sinatra::SubmissionsHelper
      helpers Sinatra::SiteTitleHelper
      helpers Sinatra::GravatarHelper
      helpers Sinatra::ProfileHelper

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

        def language_icon(language,html={})
          %{<div class="language circle #{html[:class]} #{language}-icon">&nbsp;</div>}
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
          %{<li class="#{active_nav(path)}">
          <a href="#{path}">#{nav_text(slug)}</a>
        </li>}
        end

        def dashboard_assignment_nav(language, slug=nil, counts=nil)
          return if !counts || counts.zero?

          path = language_path_for_slug(language, slug)
          %{<li class="#{active_nav(path)}">
          <a href="#{path}">#{nav_text(slug)} (#{counts})</a>
        </li>}
        end

        def nitpicker_languages
          Exercism::Config.tracks.keys.map(&:to_s) & current_user.nitpicker_languages
        end

        def namify(slug)
          slug.to_s.split('-').map(&:capitalize).join('-')
        end

        private

        def active_languages
          ExercismWeb::Presenters::Languages.new(tracks.active.map(&:language))
        end

        def upcoming_languages
          ExercismWeb::Presenters::Languages.new(tracks.upcoming.map(&:language))
        end

        def planned_languages
          ExercismWeb::Presenters::Languages.new(tracks.planned.map(&:language))
        end

        def tracks
          @tracks ||= ExercismWeb::Presenters::Tracks.xapi
        end
      end
    end
  end
end
