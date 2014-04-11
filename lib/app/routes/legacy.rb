module ExercismWeb
  module Routes
    class Legacy < Core
      get '/logout' do
        logout
        redirect root_path
      end


      get '/please-login' do
        erb :"auth/please_login", locals: {return_path: params[:return_path]}
      end

      get '/login' do
        redirect Github.login_url(github_client_id)
      end

      get '/github/callback/?*' do
        unless params[:code]
          halt 400, "Must provide parameter 'code'"
        end

        begin
          user = Authentication.perform(params[:code], github_client_id, github_client_secret)
          login(user)
        rescue => e
          flash[:error] = "We're having trouble with logins right now. Please come back later."
        end

        if current_user.guest?
          flash[:error] = "We're having trouble with logins right now. Please come back later."
        end

        path = params[:splat].first
        path = nil if path == ""
        redirect [root_path, path].compact.join('/')
      end

      get '/code/:language/:slug/random' do |language, slug|
        please_login

        language, slug = language.downcase, slug.downcase

        exercise = Exercise.new(language, slug)

        unless current_user.nitpicker_on?(exercise)
          flash[:notice] = "You'll have access to that page when you complete #{slug} in #{language}"
          redirect '/'
        end

        submission = Submission.random_completed_for(exercise)
        total = Submission.completed_for(exercise).count

        erb :"code/random", locals: {submission: submission, total: total}
      end

      post '/comments/preview' do
        ConvertsMarkdownToHTML.convert(params[:body])
      end

      get '/dashboard/:language/?' do |language|
        redirect "/nitpick/#{language}/no-nits"
      end

      get '/dashboard/:language/:slug/?' do |language, slug|
        redirect "/nitpick/#{language}/#{slug}"
      end

      get '/nitpick/:language/?' do |language|
        redirect "/nitpick/#{language}/no-nits"
      end

      get '/nitpick/:language/:slug/?' do |language, slug|
        please_login

        presenter = current_user.nitpicks_trail?(language) ? Workload : NullWorkload
        workload = presenter.new(current_user, language, slug || 'no-nits')

        locals = {
          submissions: workload.submissions,
          language: workload.language,
          exercise: workload.slug,
          exercises: workload.available_exercises,
          breakdown: workload.breakdown
        }
        erb :"nitpick/index", locals: locals
      end


      get '/user/submissions/:key' do |key|
        redirect "/submissions/#{key}"
      end

      get '/submissions/:key' do |key|
        please_login

        submission = Submission.includes(:user, comments: :user).find_by_key(key)
        unless submission
          flash[:error] = "We can't find that submission."
          redirect '/'
        end

        submission.viewed!(current_user)
        Notification.viewed!(submission, current_user)

        title(submission.slug + " in " + submission.language + " by " + submission.user.username)

        workload = Workload.new(current_user, submission.language, submission.slug)
        next_submission = workload.next_submission(submission)

        erb :"submissions/show", locals: {submission: submission, next_submission: next_submission, sharing: Sharing.new}
      end

      # TODO: Submit to this endpoint rather than the `respond` one.
      post '/submissions/:key/nitpick' do |key|
        nitpick(key)
        redirect "/submissions/#{key}"
      end

      post '/submissions/:key/respond' do |key|
        nitpick(key)
        redirect "/submissions/#{key}"
      end

      post '/submissions/:key/like' do |key|
        please_login "You have to be logged in to do that."
        submission = Submission.find_by_key(key)
        submission.like!(current_user)
        Notify.source(submission, 'like', current_user)
        redirect "/submissions/#{key}"
      end

      # Provide unlike, mute, and unmute actions.
      {
        "unlike" => "The submission has been unliked.",
        "mute" => "The submission has been muted. It will reappear when there has been some activity.",
        "unmute" => "The submission has been unmuted."
      }.each do |action, confirmation|
        post "/submissions/:key/#{action}" do |key|
          please_login "You have to be logged in to do that."
          submission = Submission.find_by_key(key)
          submission.send("#{action}!", current_user)
          flash[:notice] = confirmation
          redirect "/submissions/#{key}"
        end
      end

      get '/submissions/:key/nits/:nit_id/edit' do |key, nit_id|
        please_login("You have to be logged in to do that")
        submission = Submission.find_by_key(key)
        nit = submission.comments.where(id: nit_id).first
        unless current_user == nit.nitpicker
          flash[:notice] = "Only the author may edit the text."
          redirect "/submissions/#{key}"
        end
        erb :"submissions/edit_nit", locals: {submission: submission, nit: nit}
      end

      post '/submissions/:key/done' do |key|
        please_login("You have to be logged in to do that")
        submission = Submission.find_by_key(key)
        unless current_user.owns?(submission)
          flash[:notice] = "Only the submitter may complete the exercise."
          redirect "/submissions/#{key}"
        end
        Completion.new(submission).save
        flash[:success] = "#{submission.name} in #{submission.language} will no longer appear in the nitpick lists."
        redirect "/"
      end

      post '/submissions/:key/nits/:nit_id' do |key, nit_id|
        nit = Submission.find_by_key(key).comments.where(id: nit_id).first
        unless current_user == nit.nitpicker
          flash[:notice] = "Only the author may edit the text."
          redirect '/'
        end

        nit.body = params["body"]
        nit.save
        redirect "/submissions/#{key}"
      end

      delete '/submissions/:key/nits/:nit_id' do |key, nit_id|
        submission = Submission.find_by_key(key)
        nit = submission.comments.where(id: nit_id).first
        unless current_user == nit.nitpicker
          flash[:notice] = "Only the author may delete the text."
          redirect '/'
        end

        nit.delete
        submission.nit_count -= 1 unless current_user.owns?(submission)
        submission.save
        redirect "/submissions/#{key}"
      end


      get '/submissions/:language/:assignment' do |language, assignment|
        please_login

        unless current_user.locksmith?
          flash[:notice] = "This is an admin-only area. Sorry."
          redirect '/'
        end

        submissions = Submission.where(language: language, slug: assignment, state: ['pending', 'done'])
        .includes(:user)
        .order('created_at DESC').to_a

        erb :"submissions/assignment", locals: {submissions: submissions, language: language, assignment: assignment}
      end

      post '/submissions/:key/reopen' do |key|
        please_login
        selected_submission = Submission.find_by_key(key)
        unless current_user.owns?(selected_submission)
          flash[:notice] = "Only the current submitter may reopen the exercise"
          redirect '/'
        end

        submission = Submission.where(user_id: current_user.id, language: selected_submission.language, slug: selected_submission.slug, state: 'done').first
        submission.state = 'pending'
        submission.done_at = nil
        submission.save
        Hack::UpdatesUserExercise.new(submission.user_id, submission.language, submission.slug).update
        redirect "/submissions/#{submission.key}"
      end

      get '/teams/?' do
        please_login

        erb :"teams/new", locals: {team: Team.new}
      end

      post '/teams/?' do
        please_login

        team = Team.by(current_user).defined_with(params[:team])
        if team.valid?
          team.save
          notify(team.unconfirmed_members, team)
          redirect "/teams/#{team.slug}"
        else
          erb :"teams/new", locals: {team: team}
        end
      end

      get '/teams/:slug' do |slug|
        please_login

        team = Team.find_by_slug(slug)

        if team

          unless team.includes?(current_user)
            flash[:error] = "You may only view team pages for teams that you are a member of, or that you manage."
            redirect "/"
          end

          erb :"teams/show", locals: {team: team, members: team.all_members.sort_by {|m| m.username.downcase}}
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      delete '/teams/:slug' do |slug|
        please_login

        team = Team.find_by_slug(slug)

        if team
          unless team.managed_by?(current_user)
            flash[:error] = "You are not allowed to delete the team."
            redirect "/teams/#{slug}"
          end

          team.destroy

          flash[:success] = "Team #{slug} has been destroyed"
          redirect "/account"
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      post '/teams/:slug/members' do |slug|
        please_login

        team = Team.find_by_slug(slug)

        if team
          unless team.managed_by?(current_user)
            flash[:error] = "You are not allowed to add team members."
            redirect "/teams/#{slug}"
          end

          team.recruit(params[:usernames])
          team.save
          invitees = User.find_in_usernames(params[:usernames].to_s.scan(/[\w-]+/))
          notify(invitees, team)

          redirect "/teams/#{slug}"
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      put '/teams/:slug/leave' do |slug|
        please_login

        team = Team.find_by_slug(slug)

        if team
          team.dismiss(current_user.username)

          redirect "/#{current_user.username}"
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      delete '/teams/:slug/members/:username' do |slug, username|
        please_login

        team = Team.find_by_slug(slug)

        if team
          unless team.managed_by?(current_user)
            flash[:error] = "You are not allowed to remove team members."
            redirect "/teams/#{slug}"
          end

          team.dismiss(username)

          redirect "/teams/#{slug}"
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      put '/teams/:slug' do |slug|
        please_login

        team = Team.find_by_slug(slug)

        if team
          unless team.managed_by?(current_user)
            flash[:error] = "You are not allowed to edit the team."
            redirect "/teams/#{slug}"
          end

          if team.defined_with(params[:team]).save
            redirect "/teams/#{team.slug}"
          else
            flash[:error] = "Slug can't be blank"
            redirect "/teams/#{team.slug}"
          end
        end
      end

      put '/teams/:slug/confirm' do |slug|
        please_login

        team = Team.find_by_slug(slug)

        if team
          unless team.unconfirmed_members.include?(current_user)
            flash[:error] = "You don't have a pending invitation to this team."
            redirect "/"
          end

          team.confirm(current_user.username)

          redirect "/teams/#{slug}"
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      post "/teams/:slug/managers" do |slug|
        please_login

        team = Team.find_by_slug(slug)

        unless team.managed_by?(current_user)
          flash[:error] = "You are not allowed to add managers to the team."
          redirect "/teams/#{slug}"
        end

        user = User.find_by_username(params[:username])
        unless user.present?
          flash[:error] = "Unable to find user #{params[:username]}"
          redirect "/teams/#{slug}"
        end

        team.managed_by(user)

        redirect "/teams/#{slug}"
      end

      delete "/teams/:slug/managers" do |slug|
        please_login

        team = Team.find_by_slug(slug)

        unless team.managed_by?(current_user)
          flash[:error] = "You are not allowed to add managers to the team."
          redirect "/teams/#{slug}"
        end

        user = User.find_by_username(params[:username])
        team.managers.delete(user) if user
        redirect "/teams/#{slug}"
      end

      post "/teams/:slug/disown" do |slug|
        please_login("/teams/#{slug}")

        team = Team.find_by_slug(slug)

        if team.managers.size == 1
          flash[:error] = "You can't quit when you're the only manager."
          redirect "/teams/#{slug}"
        else
          team.managers.delete(current_user)
          redirect "/account"
        end
      end

      private

      def notify(invitees, team)
        invitees.each do |invitee|
          attributes = {
            user_id: invitee.id,
            url: '/account',
            text: "#{current_user.username} would like you to join the team #{team.name}. You can accept the invitation",
            link_text: 'on your account page.'
          }
          Alert.create(attributes)
          begin
            TeamInvitationMessage.ship(
              instigator: current_user,
              target: {
                team_name: team.name,
                invitee: invitee
              },
              site_root: site_root
            )
          rescue => e
            puts "Failed to send email. #{e.message}."
          end
        end
      end

      get '/exercises/:language/:slug' do |language, slug|
        response = Xapi.get("exercises", language, slug)
        exercise = JSON.parse(response)["assignments"].first
        language = exercise["track"]
        slug = exercise["slug"]
        text = exercise["files"].find {|filename, code| filename =~ /test/i}.last
        erb :"exercises/test_suite", locals: {language: language, slug: slug, text: text}
      end

      get '/exercises/:language/:slug/readme' do |language, slug|
        response = Xapi.get("exercises", language, slug)
        exercise = JSON.parse(response)["assignments"].first
        text = exercise["files"].find {|key, value| key == "README.md"}.last
        erb :"exercises/readme", locals: {text: text}
      end

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
