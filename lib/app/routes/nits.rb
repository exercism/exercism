module ExercismWeb
  module Routes
    class Nits < Core
      get '/nits/:username' do |username|
        redirect "/nits/%s/stats" % username
      end

      get '/nits/:username/stats' do |username|
        please_login
        user = ::User.find_by_username(username)
        if user
          stats = Nitstats.new(user)
          title("#{user.username} - Nit Stats")
          erb :"nits/stats", locals: {user: user, stats: stats }
        else
          status 404
          erb :"errors/not_found"
        end
      end

      get '/nits/:username/given' do
        please_login

        nitpicks = current_user.comments
        .reversed
        .paginate_by_params(params)

        erb :"nits/given", locals: {user: current_user, nitpicks: nitpicks}
      end

      get '/nits/:username/received' do
        please_login

        nitpicks = Comment.received_by(current_user)
        .reversed
        .paginate_by_params(params)

        erb :"nits/received", locals: {user: current_user, nitpicks: nitpicks}
      end
    end
  end
end
