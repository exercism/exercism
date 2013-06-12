class ExercismApp < Sinatra::Base

  post '/user/:trail/start' do |language|
    begin
      Launch.new(current_user, language).start
      redirect '/'
    rescue
      halt 400, "Language #{language} is not supported at this time."
    end
  end

end
