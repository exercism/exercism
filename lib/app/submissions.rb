class ExercismApp < Sinatra::Base

  get '/user/submissions/:id' do |id|
    submission = Submission.find(id)
    unless current_user == submission.user
      halt 403, "This is not your exercise."
    end
    erb :current_submission, locals: {submission: Submission.find(id)}
  end

  get '/submissions/:id' do |id|
    submission = Submission.find(id)
    unless current_user.may_nitpick?(submission.exercise)
      halt 403, "You do not have permission to nitpick this exercise."
    end
    erb :nitpick, locals: {submission: submission}
  end

  post '/submissions/:id/nitpick' do |id|
    submission = Submission.find(id)

    unless current_user.may_nitpick?(submission.exercise)
      halt 403, "You do not have permission to nitpick this exercise."
    end

    Nitpick.new(id, current_user, params[:comment]).save
    redirect '/'
  end

  post '/submissions/:id/approve' do |id|
    unless current_user.admin?
      halt 403, "You do not have permission to approve this exercise."
    end
    Approval.new(id, current_user).save
    redirect '/'
  end

end
