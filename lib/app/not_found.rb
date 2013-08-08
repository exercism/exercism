class ExercismApp < Sinatra::Base
  [:get, :post, :put, :delete].each do |verb|
    send(verb, '*') { erb :not_found }
  end
end
