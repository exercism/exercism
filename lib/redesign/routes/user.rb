module ExercismIO
  module Routes
    class User < Core
      get '/:username/profile' do |username|
        user = ::User.find_by_username(username)
        haml :"user/profile", locals: {profile: ExercismIO::Presenters::Profile.new(user)}
      end
    end
  end
end
