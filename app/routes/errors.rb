module ExercismWeb
  module Routes
    class Errors < Core
      [:get, :post, :put, :delete].each do |verb|
        send(verb, '*') do
          status 404
          erb :"errors/not_found"
        end
      end
    end
  end
end
