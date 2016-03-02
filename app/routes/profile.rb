module ExercismWeb
  module Routes
    class Profile < Core
      get '/profiles/:username/:share_key' do |username, key|
        user = ::User.find_by(username: username, share_key: key)
        if user
          title(user.username)
          erb :"user/show", locals: { profile: Presenters::Profile.new(user, current_user, shared: true) }
        else
          status 404
          erb :"errors/not_found"
        end
      end
    end
  end
end
