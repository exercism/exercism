class ExercismApp < Sinatra::Base

  helpers do
    def nitpick(id)
      notice = "You're not logged in right now. Go back, copy the text, log in, and try again. Sorry about that."
      please_login(notice)

      submission = Submission.find(id)
      nitpick = Nitpick.new(id, current_user, params[:comment])
      nitpick.save
      if nitpick.nitpicked?
        Notify.everyone(submission, 'nitpick', except: current_user)
        begin
          unless nitpick.nitpicker == nitpick.submission.user
            NitpickMessage.ship(
              instigator: nitpick.nitpicker,
              submission: nitpick.submission,
              site_root: site_root
            )
          end
        rescue => e
          puts "Failed to send email. #{e.message}."
        end
      end
      submission.unmute_all!
    end

    def toggle_opinions(id, state)
      submission = Submission.find(id)

      unless current_user.owns?(submission)
        flash[:error] = "You do not have permission to do that."
        redirect '/'
      end

      submission.send("#{state}_opinions!")
      submission.unmute_all! if submission.wants_opinions?

      if submission.wants_opinions?
        flash[:notice] = "Your request for more opinions has been made. You can disable this below when all is clear."
      else
        flash[:notice] = "Your request for more opinions has been disabled."
      end
    end
  end

  get '/user/submissions/:id' do |id|
    redirect "/submissions/#{id}"
  end

  get '/submissions/:id' do |id|
    please_login

    submission = Submission.find(id)
    submission.viewed!(current_user)

    title(submission.slug + " in " + submission.language + " by " + submission.user.username)

    erb :submission, locals: {submission: submission}
  end

  # TODO: Submit to this endpoint rather than the `respond` one.
  post '/submissions/:id/nitpick' do |id|
    nitpick(id)
    redirect "/submissions/#{id}"
  end

  post '/submissions/:id/respond' do |id|
    nitpick(id)
    redirect "/submissions/#{id}"
  end

  post '/submissions/:id/like' do |id|
    please_login "You have to be logged in to do that."
    submission = Submission.find(id)
    submission.like!(current_user)
    Notify.source(submission, 'like')
    redirect "/submissions/#{id}"
  end

  post '/submissions/:id/unlike' do |id|
    please_login "You have to be logged in to do that."
    submission = Submission.find(id)
    submission.unlike!(current_user)
    flash[:notice] = "The submission has been unliked."
    redirect "/submissions/#{id}"
  end

  post '/submissions/:id/opinions/enable' do |id|
    please_login "You have to be logged in to do that."
    toggle_opinions(id, :enable)
    redirect "/submissions/#{id}"
  end

  post '/submissions/:id/opinions/disable' do |id|
    please_login "You have to be logged in to do that."
    toggle_opinions(id, :disable)
    redirect "/submissions/#{id}"
  end

  post '/submissions/:id/mute' do |id|
    please_login "You have to be logged in to do that."
    submission = Submission.find(id)
    submission.mute!(current_user)
    flash[:notice] = "The submission has been muted. It will reappear when there has been some activity."
    redirect '/'
  end

  post '/submissions/:id/unmute' do |id|
    please_login "You have to be logged in to do that."
    submission = Submission.find(id)
    submission.unmute!(current_user)
    flash[:notice] = "The submission has been unmuted."
    redirect '/'
  end

  get '/submissions/:id/nits/:nit_id/edit' do |id, nit_id|
    please_login("You have to be logged in to do that")
    submission = Submission.find(id)
    nit = submission.comments.where(id: nit_id).first
    unless current_user == nit.nitpicker
      flash[:notice] = "Only the author may edit the text."
      redirect "/submissions/#{id}"
    end
    erb :edit_nit, locals: {submission: submission, nit: nit}
  end

  post '/submissions/:id/done' do |id|
    please_login("You have to be logged in to do that")
    submission = Submission.find id
    unless current_user.owns?(submission)
      flash[:notice] = "Only the submitter may unlock the next exercise."
      redirect "/submissions/#{id}"
    end
    completion = Completion.new(submission).save
    flash[:success] = "#{completion.unlocked} unlocked."
    redirect "/"
  end

  post '/submissions/:id/nits/:nit_id/edit' do |id, nit_id|
    nit = Submission.find(id).comments.where(id: nit_id).first
    unless current_user == nit.nitpicker
      flash[:notice] = "Only the author may edit the text."
    end

    nit.sanitized_update(params['comment'])
    redirect "/submissions/#{id}"
  end

  get '/submissions/:language/:assignment' do |language, assignment|
    please_login

    unless current_user.locksmith?
      flash[:notice] = "This is an admin-only area. Sorry."
      redirect '/'
    end

    submissions = Submission.where(l: language, s: assignment)
                            .in(state: ["pending", "done"])
                            .includes(:user)
                            .desc(:at).to_a

    erb :submissions_for_assignment, locals: { submissions: submissions,
                                                  language: language,
                                                assignment: assignment }
  end
end
