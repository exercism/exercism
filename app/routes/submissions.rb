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
          submission.viewed_by(current_user) # in support of inbox
          Notification.viewed!(submission, current_user)
        end

        title("%s by %s in %s" % [submission.problem.name, submission.user.username, submission.problem.language])

        locals = {
          submission: submission,
          own_uuid: submission.exercise_uuid_by(current_user),
        }

        erb :"submissions/show", locals: locals
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

      post "/submissions/:key/unlike" do |key|
        please_login "You have to be logged in to do that."
        submission = Submission.find_by_key(key)
        submission.unlike!(current_user)
        submission.notifications.unread.where(action: 'like', actor_id: current_user.id).destroy_all
        flash[:notice] = "The submission has been unliked."
        redirect "/submissions/#{key}"
      end

      get %r{^/submissions/(?<key>\w+)/(nitpick$|(\+?un)?like$)} do |key|
        redirect "/submissions/#{key}"
      end

      delete '/submissions/:key' do |key|
        please_login
        submission = Submission.find_by_key(key)
        redirect '/' if submission.nil?

        unless current_user.owns?(submission)
          flash[:notice] = "Only the author may delete the exercise."
          redirect '/'
        end

        decrement_version(submission)
        submission.user_exercise.decrement_iteration_count!
        submission.destroy
        Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
        redirect "/dashboard"
      end
    end
  end
end
