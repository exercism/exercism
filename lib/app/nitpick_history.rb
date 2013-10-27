class ExercismApp < Sinatra::Base

  get '/user/history' do
    please_login

    nitpicks = current_user.comments
                           .paginate(page: params[:page], per_page: per_page)

    erb :history, locals: {nitpicks: nitpicks}
  end

  private

  def per_page
    params[:per_page] || 10
  end

end
