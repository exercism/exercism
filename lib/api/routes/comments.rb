require 'exercism/rikki'

module ExercismAPI
  module Routes
    class Comments < Core
      # Submit a rikki- comment.
      # Only the rikki- daemon uses this endpoint.
      post '/submissions/:key/comments' do |key|
        unless Rikki.validate(params[:shared_key])
          halt 401, {error: "access denied"}
        end

        submission = Submission.find_by_key(key)
        if submission.nil?
          halt 404, {error: "unknown submission #{key}"}.to_json
        end

        user = User.find_by_username('rikki-')
        if user.nil?
          halt 400, {error: "cannot find rikki- the robot (submission: #{key})"}.to_json
        end

        body = request.body.read.to_s
        comment = JSON.parse(body)["comment"].to_s
        if comment.empty?
          halt 400, {error: "no comment submitted (submission: #{key})"}.to_json
        end

        if submission.comments.where(user_id: user.id).count > 0
          halt 204
        end

        submission.comments.create(user: user, body: comment)
        Notification.on(submission, to: submission.user, regarding: 'nitpick', creator: user)
        halt 204
      end
    end
  end
end
