require 'haml'
require 'exercism'

class Exercism
  module App
    def self.root
      'v1.0'
    end
  end
end

require 'app/helpers/article_helper'
require 'app/helpers/fuzzy_time_helper'
require 'app/helpers/markdown_helper'

require 'app/site/languages'
[
  'site/carousel', 'user/navigation', 'user/account',
  'user/track', 'user/exercise', 'user/comment'
].each do |presenter|
  require File.join(Exercism::App.root, presenter)
end

['site', 'help', 'user'].each do |controller|
  require File.join(Exercism::App.root, controller)
end

class ExercismV1p0 < Sinatra::Base
  set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
  set :root, File.join('lib', Exercism::App.root)

  helpers Sinatra::ArticleHelper
  helpers Sinatra::FuzzyTimeHelper
  helpers Sinatra::MarkdownHelper

  helpers do
    def root_path
      "/v1.0"
    end

    def link_to(path)
      File.join(root_path, path)
    end
  end
end
