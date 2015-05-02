module ExercismWeb
  module Routes
    class Comments < Core
      post '/submissions/:key/nitpick' do |key|
        notice = "You're not logged in right now. Please log in via GitHub to comment."
        please_login(notice)
        submission = Submission.find_by({key: key})
        if submission.nil?
          flash[:notice] = "Cannot comment on this submission anymore, because it has been deleted."
          redirect "/"
        end
        comment = CreatesComment.create(submission.id, current_user, params[:body])
        unless comment.new_record?
          Notify.everyone(submission, 'nitpick', current_user)
          unless current_user == submission.user
            LifecycleEvent.track('received_feedback', submission.user_id)
            LifecycleEvent.track('commented', current_user.id)
            unless current_user.onboarded?
              LifecycleEvent.commented(current_user.id)
            end
          end
        end
        redirect "/submissions/#{key}"
      end

      post '/comments/preview' do
        ConvertsMarkdownToHTML.convert(params[:body])
      end

      get '/submissions/:key/nits/:nit_id/edit' do |key, nit_id|
        please_login("You have to be logged in to do that")
        submission = Submission.find_by_key(key)
        if submission.nil?
          redirect '/'
        end
        nit = submission.comments.where(id: nit_id).first
        if nit.nil?
          flash[:notice] = "no such comment"
          redirect "/submissions/#{key}"
        end
        unless current_user == nit.nitpicker
          flash[:notice] = "Only the author may edit the text."
          redirect "/submissions/#{key}"
        end
        erb :"submissions/edit_nit", locals: {submission: submission, nit: nit}
      end

      post '/submissions/:key/nits/:nit_id' do |key, nit_id|
        nit = Submission.find_by_key(key).comments.where(id: nit_id).first
        if nit.nil?
          redirect "/submissions/#{key}"
        end

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
    end
  end
end
