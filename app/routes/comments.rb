module ExercismWeb
  module Routes
    class Comments < Core
      post '/submissions/:key/nitpick' do |key|
        notice = "You're not logged in right now. Please log in via GitHub to comment."
        please_login(notice)

        submission = Submission.find_by(key: key)
        if submission.nil?
          flash[:notice] = "Cannot comment on this submission anymore, because it has been deleted."
          redirect "/"
        end

        url = "/submissions/#{key}"

        redirect url if params[:body].empty?

        comment = CreatesComment.create(submission.id, current_user, params[:body])

        redirect url if comment.new_record?

        current_user.increment_daily_count if comment.qualifying?
        Notify.everyone(submission, 'comment', current_user)

        comment.mention_ids.each do |user_id|
          Notification.on(submission, user_id: user_id, action: 'mention', actor_id: comment.user_id)
        end

        ConversationSubscription.join(current_user, submission)

        redirect "/submissions/#{key}"
      end

      post '/comments/preview' do
        ConvertsMarkdownToHTML.convert(params[:body])
      end

      get '/submissions/:key/nits/:nit_id/edit' do |key, nit_id|
        please_login("You have to be logged in to do that")
        submission = Submission.find_by_key(key)
        redirect '/' if submission.nil?
        nit = submission.comments.where(id: nit_id).first
        if nit.nil?
          flash[:notice] = "no such comment"
          redirect "/submissions/#{key}"
        end
        unless current_user == nit.nitpicker
          flash[:notice] = "Only the author may edit the text."
          redirect "/submissions/#{key}"
        end
        erb :"submissions/edit_nit", locals: { submission: submission, nit: nit }
      end

      post '/submissions/:key/nits/:nit_id' do |key, nit_id|
        nit = Submission.find_by_key(key).comments.where(id: nit_id).first
        redirect "/submissions/#{key}" if nit.nil?

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
        submission.save
        redirect "/submissions/#{key}"
      end
    end
  end
end
