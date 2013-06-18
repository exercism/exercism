class ExercismApp < Sinatra::Base

  get '/user/submissions/:id' do |id|
    submission = Submission.find(id)
    unless current_user == submission.user
      flash[:error] = 'That is not your submission.'
    end
    erb :current_submission, locals: {submission: Submission.find(id)}
  end

  get '/submissions/:id' do |id|
    submission = Submission.find(id)
    unless current_user.may_nitpick?(submission.exercise)
      flash[:error] = "You do not have permission to nitpick that exercise."
      redirect '/'
    end
    erb :nitpick, locals: {submission: submission}
  end

  post '/submissions/:id/nitpick' do |id|
    submission = Submission.find(id)

    unless current_user.may_nitpick?(submission.exercise)
      halt 403, "You do not have permission to nitpick that exercise."
    end

    Nitpick.new(id, current_user, params[:comment]).save
    redirect '/'
  end

  post '/submissions/:id/approve' do |id|
    unless current_user.admin?
      halt 403, "You do not have permission to approve that exercise."
    end
    Approval.new(id, current_user).save
    redirect '/'
  end

end
