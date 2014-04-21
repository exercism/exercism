module ExercismIO
  module Routes
    class Help < Core
      get '/help' do
        haml :"help/index", locals: {email: '_@kytrinyx.com'}
      end
    end
  end
end
