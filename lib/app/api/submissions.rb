class ExercismApp < Sinatra::Base
  get '/api/v1/submission/:id' do |id|
    user = submission_user
    submission = load_submission(id)
    pg :submission, locals: { submission: submission, user: user }
  end

  private
  def submission_user
    if params[:key]
      User.find_by(key: params[:key])
    elsif request.cookies['_exercism_login']
      current_user
    else
      no_user_error
    end
  end

  def no_user_error
    halt 401, { error: "Please provide API key or valid session" }.to_json
  end

  def load_submission(id)
    submission = Submission.where(id: id).first
    halt 404, { error: "Submission not found" } unless submission
    submission
  end
end
