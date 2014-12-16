module ExercismWeb
  module Routes
    class CommentThreads < Core
      post '/comments/:comment_id/comment_threads' do |comment_id|
        content_type :json
        please_login

        comment = Comment.find comment_id
        ct = CommentThread.new(
          body: params[:body],
          user: current_user,
          comment: comment
        )

        if ct.save
          ct.to_json
        else
          status 422
          ct.errors.to_json
        end
      end
    end
  end
end
