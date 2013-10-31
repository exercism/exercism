class ExercismApp < Sinatra::Base

  get '/user/history' do
    please_login

    per_page = params[:per_page] || 10

    nitpicks = current_user.comments
                           .order('created_at DESC')
                           .paginate(page: params[:page], per_page: per_page)

    erb :history, locals: {nitpicks: nitpicks}
  end
end
