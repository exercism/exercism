class ExercismApp < Sinatra::Base

  get '/:username' do |username|
    please_login
    user = User.find_by_username(username)

    if user
      title(user.username)
      erb :"user/show", locals: { profile: Profile.new(user, current_user) }
    else
      status 404
      erb :not_found
    end
  end

  get '/:username/nitstats' do |username|
    please_login
    user = User.find_by_username(username)
    if user
      stats = Nitstats.new(user)
      title("#{user.username} - Nit Stats")
      erb :"user/nitstats", locals: {user: user, stats: stats }
    else
      status 404
      erb :not_found
    end
  end

  get '/:username/history' do
    please_login

    per_page = params[:per_page] || 10

    nitpicks = current_user.comments
                           .order('created_at DESC')
                           .paginate(page: params[:page], per_page: per_page)

    erb :"user/history", locals: {nitpicks: nitpicks}
  end
end
