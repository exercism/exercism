module ExercismWeb
  module Routes
    class Exercises < Core
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
    end
  end
end
