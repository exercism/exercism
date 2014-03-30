require 'haml'
require 'exercism'

class Exercism
  module App
    def self.root
      'v1.0'
    end
  end
end

[
  'session_helper'
].each do |helper|
  require File.join(Exercism::App.root, 'helpers', helper)
end

[
  'markdown', 'article', 'fuzzy_time'
].each do |helper|
  require File.join('redesign', 'helpers', helper)
end

[
  'user/navigation', 'user/account',
  'user/track', 'user/exercise', 'user/comment',
  'user/active_exercise', 'user/notification',
  'user/truncated_exercises', 'user/profile',
].each do |presenter|
  require File.join(Exercism::App.root, presenter)
end
require File.join('redesign', 'presenters', 'languages')
require File.join('redesign', 'presenters', 'carousel')

['auth', 'alerts', 'site', 'help', 'exercises', 'solutions', 'teams', 'user'].each do |controller|
  require File.join(Exercism::App.root, controller)
end

class ExercismV1p0 < Sinatra::Base
  set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
  set :root, File.join('lib', Exercism::App.root)
  set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
  set :method_override, true

  enable :sessions

  helpers ExercismIO::Helpers::FuzzyTimeHelper
  helpers ExercismIO::Helpers::Article
  helpers ExercismIO::Helpers::Markdown
  helpers Sinatra::SessionHelper

  helpers do
    def github_client_id
      ENV.fetch('EXERCISM_V1P0_GITHUB_CLIENT_ID')
    end

    def github_client_secret
      ENV.fetch('EXERCISM_V1P0_GITHUB_CLIENT_SECRET')
    end

    def site_root
      env.fetch('HTTP_HOST') { 'http://exercism.io' } << root_path
    end

    def root_path
      "/v1.0"
    end

    def link_to(path)
      File.join(root_path, path)
    end

    def nav
      @nav ||= App::User::Navigation.new(current_user)
    end
  end
end
