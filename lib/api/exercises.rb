require 'api/exercises/homework'

class ExercismAPI < Sinatra::Base
  get '/exercises' do
    require_user
    content_type 'application/json', :charset => 'utf-8'
    Homework.new(current_user).all.to_json
  end
end
