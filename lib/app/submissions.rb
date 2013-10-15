class ExercismApp < Sinatra::Base

  helpers do
    def nitpick(key)
      notice = "You're not logged in right now. Go back, copy the text, log in, and try again. Sorry about that."
      please_login(notice)

      submission = Submission.find_by_key(key)
      comment = CreatesComment.create(submission.id, current_user, params[:body])
      unless comment.new_record?
        Notify.everyone(submission, 'nitpick', except: current_user)
        begin
          unless comment.nitpicker == submission.user
            CommentMessage.ship(
              instigator: comment.nitpicker,
              submission: submission,
              site_root: site_root
            )
          end
        rescue => e
          puts "Failed to send email. #{e.message}."
        end
      end
      submission.unmute_all!
    end

    def toggle_opinions(key, state)
      submission = Submission.find_by_key(key)

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

  get '/user/submissions/:key' do |key|
    redirect "/submissions/#{key}"
  end

  get '/submissions/:key' do |key|
    please_login

    submission = Submission.find_by_key(key)
    submission.viewed!(current_user)

    title(submission.slug + " in " + submission.language + " by " + submission.user.username)

    erb :submission, locals: {submission: submission}
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
    Notify.source(submission, 'like')
    redirect "/submissions/#{key}"
  end

  post '/submissions/:key/unlike' do |key|
    please_login "You have to be logged in to do that."
    submission = Submission.find_by_key(key)
    submission.unlike!(current_user)
    flash[:notice] = "The submission has been unliked."
    redirect "/submissions/#{key}"
  end

  post '/submissions/:key/opinions/enable' do |key|
    please_login "You have to be logged in to do that."
    toggle_opinions(key, :enable)
    redirect "/submissions/#{key}"
  end

  post '/submissions/:key/opinions/disable' do |key|
    please_login "You have to be logged in to do that."
    toggle_opinions(key, :disable)
    redirect "/submissions/#{key}"
  end

  post '/submissions/:key/mute' do |key|
    please_login "You have to be logged in to do that."
    submission = Submission.find_by_key(key)
    submission.mute!(current_user)
    flash[:notice] = "The submission has been muted. It will reappear when there has been some activity."
    redirect '/'
  end

  post '/submissions/:key/unmute' do |key|
    please_login "You have to be logged in to do that."
    submission = Submission.find_by_key(key)
    submission.unmute!(current_user)
    flash[:notice] = "The submission has been unmuted."
    redirect '/'
  end

  get '/submissions/:key/nits/:nit_id/edit' do |key, nit_id|
    please_login("You have to be logged in to do that")
    submission = Submission.find_by_key(key)
    nit = submission.comments.where(id: nit_id).first
    unless current_user == nit.nitpicker
      flash[:notice] = "Only the author may edit the text."
      redirect "/submissions/#{key}"
    end
    erb :edit_nit, locals: {submission: submission, nit: nit}
  end

  post '/submissions/:key/done' do |key|
    please_login("You have to be logged in to do that")
    submission = Submission.find_by_key(key)
    unless current_user.owns?(submission)
      flash[:notice] = "Only the submitter may unlock the next exercise."
      redirect "/submissions/#{key}"
    end
    completion = Completion.new(submission).save
    flash[:success] = "#{completion.unlocked} unlocked."
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
    nit = Submission.find_by_key(key).comments.where(id: nit_id).first
    unless current_user == nit.nitpicker
      flash[:notice] = "Only the author may delete the text."
      redirect '/'
    end

    nit.delete
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

    erb :submissions_for_assignment, locals: { submissions: submissions,
                                                  language: language,
                                                assignment: assignment }
  end

  get '/submissions/diff/:key/:key' do |a,b|
    please_login

    diff = Diffy::Diff.new(Submission.find_by_key(a).code, Submission.find_by_key(b).code)
    erb :"code/simple", layout: false, locals: { title: "Diff",
        html: { id: "revision-diff"},
        code: diff.to_s,
        language: 'diff',
    }

  end
end
