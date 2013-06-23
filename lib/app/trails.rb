class ExercismApp < Sinatra::Base

  post '/user/:trail/start' do |language|
    if current_user.guest?
      halt 403, 'You must log in to start a trail.'
    end
    begin
      Launch.new(current_user, language).start
      redirect '/'
    rescue
      halt 400, "Language #{language} is not supported at this time."
    end
  end

end
