module ExercismWeb
  module Routes
    class Legacy < Core
      get '/dashboard/:language/?' do |language|
        redirect "/nitpick/#{language}/no-nits"
      end

      get '/dashboard/:language/:slug/?' do |language, slug|
        redirect "/nitpick/#{language}/#{slug}"
      end

      get '/nitpick/:language/?' do |language|
        redirect "/nitpick/#{language}/no-nits"
      end

      get '/user/submissions/:key' do |key|
        redirect "/submissions/#{key}"
      end

      # Become nitpicker. How did I decide on this particular route?
      post '/exercises/:language/:slug' do |language, slug|
        please_login

        exercise = current_user.exercises.where(language: language, slug: slug).first
        exercise.unlock! if exercise
        redirect back
      end

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

      get '/:username/:key' do |username, key|
        please_login
        user = User.find_by_username(username)
        exercise = user.exercises.find_by_key(key)
        if exercise.submissions.empty?
          # We have orphan exercises at the moment.
          flash[:notice] = "That submission no longer exists."
          redirect '/'
        else
          redirect ["", "submissions", exercise.submissions.last.key].join('/')
        end
      end

      [:get, :post, :put, :delete].each do |verb|
        send(verb, '*') do
          status 404
          erb :not_found
        end
      end
    end
  end
end
