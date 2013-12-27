require 'exercism'

class Exercism
  module App
    def self.root
      'v1.0'
    end
  end
end

require 'app/helpers/article_helper'

require 'app/site/languages'
require File.join(Exercism::App.root, 'site', 'carousel')

['site', 'help'].each do |controller|
  require File.join(Exercism::App.root, controller)
end

class ExercismV1p0 < Sinatra::Base
  set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
  set :root, File.join('lib', Exercism::App.root)

  helpers Sinatra::ArticleHelper

  helpers do
    def link_to(path)
      "/" + File.join(Exercism::App.root, path)
    end
  end
end
