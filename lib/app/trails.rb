class ExercismApp < Sinatra::Base

  post '/user/:trail/start' do |language|
    # TODO: language must exist
    exercise = Exercism.current_curriculum.in(language).first
    current_user.do! exercise
    redirect '/'
  end

end
