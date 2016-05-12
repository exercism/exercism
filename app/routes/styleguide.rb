module ExercismWeb
  module Routes
    class Styleguide < Core
      get '/styleguide' do
        # https://github.com/kneath/kss/blob/master/SPEC.md
        @styleguide = Kss::Parser.new('public/sass')
        erb :"styleguide/index", layout: :styleguide
      end
    end
  end
end
