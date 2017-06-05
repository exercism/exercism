module ExercismWeb
  module Routes
    class Profile < Core
      before do
        if page_request? && $flipper[:advertise_cli_update].enabled?(current_user)
          client_version = ClientVersion.new(user: current_user)
          flash.now[:notice] ||= client_version.notice_when_client_outdated
        end
      end

      def page_request?
        request.env['HTTP_ACCEPT'].to_s.include? 'text/html'
      end

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
