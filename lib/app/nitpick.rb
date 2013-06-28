class ExercismApp < Sinatra::Base

  get '/nitpick' do
    unless current_user.nitpicker?
      flash[:error] = "Finish at least one exercise, and we'll tell you all about nitpicking!"
      redirect '/'
    end
    erb :"about/nitpick"
  end

end
