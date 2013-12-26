require 'exercism'

class Exercism
  module App
    def self.root
      'v1.0'
    end
  end
end

require File.join(Exercism::App.root, 'site')

class ExercismV1p0 < Sinatra::Base
  set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
  set :root, File.join('lib', Exercism::App.root)

  helpers do
    def link_to(path)
      "/" + File.join(Exercism::App.root, path)
    end
  end
end
