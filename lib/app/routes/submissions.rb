module ExercismWeb
  module Routes
    class Submissions < Core
      get '/submissions/:key' do |key|
        submission = Submission.includes(:user, comments: :user).find_by_key(key)
        unless submission
          flash[:error] = "We can't find that submission."
          redirect '/'
        end

        unless current_user.guest?
          session[:inbox_exercise] = submission.user_exercise_id
          submission.viewed_by(current_user) # in support of inbox
          submission.viewed!(current_user) # legacy?
          Look.check!(submission.user_exercise_id, current_user.id) # legacy?
          Notification.viewed!(submission, current_user)
        end

        title("%s by %s in %s" % [submission.problem.name, submission.user.username, submission.problem.language])

        last = session[:inbox_last] == submission.user_exercise_id

        erb :"submissions/show", locals: {submission: submission, last_in_inbox: last, sharing: Sharing.new}
      end

      post '/submissions/:key/like' do |key|
        please_login "You have to be logged in to do that."
        submission = Submission.find_by_key(key)
        if submission.nil?
          flash[:notice] = "No such exercise found"
          redirect "/"
        end

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

      get %r{/submissions/(?<key>\w+)/(nitpick$|(\+?un)?like$|(\+?un)?mute$)} do |key|
        redirect "/submissions/#{key}"
      end

      delete '/submissions/:key' do |key|
        please_login
        submission = Submission.find_by_key(key)
        if submission.nil?
          redirect '/'
        end

        unless current_user.owns?(submission)
          flash[:notice] = "Only the author may delete the exercise."
          redirect '/'
        end

        decrement_version(submission)
        prior = submission.prior
        if prior && (submission.state == 'pending')
          prior.state = 'pending'
          prior.save
        end
        submission.destroy
        Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
        redirect "/"
      end
    end
  end
end
