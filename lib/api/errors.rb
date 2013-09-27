class ExercismAPI < Sinatra::Base
  [:get, :post, :put, :delete].each do |verb|
    send(verb, '*') do
      status 404
      erb :not_found
    end
  end
end
