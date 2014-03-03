module ExercismIO
  module Routes
    class Home < Core
      get '/' do
        haml :"home/index", locals: {email: '_@kytrinyx.com'}
      end
    end
  end
end
