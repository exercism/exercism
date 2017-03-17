require 'active_record'
require 'exercism/user'

module FlipperApp
  class Authorize
    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      if authorized?(env)
        @app.call(env)
      else
        forbidden
      end
    end

    private

    def authorized_usernames
      %w(kytrinyx nilbus)
    end

    def authorized_github_ids
      @authorized_github_ids ||=
        User.where(username: authorized_usernames).pluck(:github_id)
    end

    def authorized?(env)
      development? || authorized_user?(env)
    end

    def authorized_user?(env)
      session = env['rack.session'] || {}
      authorized_github_ids.include? session['github_id']
    end

    def development?
      ENV['RACK_ENV'] == 'development'
    end

    def forbidden
      [403, {"Content-Type" => "text/html"}, [deny_markup]]
    end

    def deny_markup
      '<html><body><img src="https://octodex.github.com/images/bouncercat.png"></body></html>'
    end
  end
end
