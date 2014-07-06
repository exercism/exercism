module ExercismWeb
  module Routes
    class Core < Sinatra::Application
      configure do
        set :root, Exercism.relative_to_root('lib', 'app')
        set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
        set :method_override, true
      end

      use Rack::Flash
      use Bugsnag::Rack

      helpers Helpers::NotificationCount # total hack
      helpers Helpers::FuzzyTime
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
          ::User.order('created_at DESC').limit(100)
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

        def show_pending_submissions?(language)
          (!language && current_user.nitpicker?) || (language && current_user.nitpicks_trail?(language))
        end

        def nitpicker_languages
          Exercism::Config.languages.keys.map(&:to_s) & current_user.nitpicker_languages
        end

        def progress(language)
          summary = Hash.new {|hash, key| hash[key] = {}}
          Submission.select('slug, state, count(id)').where(language: language).group(:slug, :state).each do |submission|
            summary[submission.slug][submission.state] = submission.count.to_i
          end
          sql = "SELECT s.slug, COUNT(c.id) nits FROM comments c INNER JOIN submissions s ON c.submission_id=s.id WHERE s.language=? GROUP BY slug"
          query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, language])

          Submission.connection.execute(query).to_a.each do |submission|
            summary[submission["slug"]]["nits"] = submission["nits"]
          end
          summary
        end

        def quantify(value)
          q = value.to_i
          q > 0 ? q : nil
        end

        def namify(slug)
          slug.to_s.split('-').map(&:capitalize).join('-')
        end
      end

    end
  end
end
