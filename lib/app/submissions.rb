class ExercismApp < Sinatra::Base

  get '/user/submissions/:id' do |id|
    erb :current_submission, locals: {submission: Submission.find(id)}
  end

end
