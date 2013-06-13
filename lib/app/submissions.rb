class ExercismApp < Sinatra::Base

  get '/user/submissions/:id' do |id|
    erb :current_submission, locals: {submission: Submission.find(id)}
  end

  get '/submissions/:id' do |id|
    erb :nitpick, locals: {submission: Submission.find(id)}
  end

  post '/submissions/:id/nitpick' do |id|
    Nitpick.new(id, current_user, params[:comment]).save
    redirect '/'
  end

end
