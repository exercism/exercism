require 'exercism/rikki'
require './x/signature'

module ExercismAPI
  module Routes
    class Comments < Core
      # Submit a rikki- comment.
      # Only the rikki- daemon uses this endpoint.
      post '/submissions/:key/comments' do |key|
        unless Rikki.validate(params[:shared_key])
          halt 401, error: "access denied"
        end

        submission = Submission.find_by_key(key)
        if submission.nil?
          halt 404, { error: "unknown submission #{key}" }.to_json
        end

        user = User.find_by_username('rikki-')
        if user.nil?
          halt 400, { error: "cannot find rikki- the robot (submission: #{key})" }.to_json
        end

        body = request.body.read.to_s
        comment = JSON.parse(body)["comment"].to_s
        if comment.empty?
          halt 400, { error: "no comment submitted (submission: #{key})" }.to_json
        end

        halt 204 if submission.comments.where(user_id: user.id).count > 0

        # only respond to the most recent iteration
        uuid = Submission.where(user_exercise_id: submission.user_exercise_id).order('created_at DESC').limit(1).pluck('key').first
        halt 204 if uuid != submission.key

        c = submission.comments.create(user: user, body: comment)
        ex = submission.user_exercise
        # If we're running rikki- against historical data, we don't want to flood
        # the inbox with ancient iterations.
        ex.update_last_activity(c).save if ex.last_activity_at > 1.week.ago
        ConversationSubscription.join(user, submission)
        Notification.on(submission, user_id: submission.user_id, action: 'comment', actor_id: user.id)
        halt 204
      end

      # A more secure endpoint for posting comments.
      # At the moment only rikki- will be using this, since
      # we don't expose the api key and secret to other users.
      # We may need to change the logic if someone other than rikki- starts
      # using the endpoint.
      post '/comments' do
        payload = JSON.parse(request.body.read.to_s)

        # request must not be expired
        halt 403, "Forbidden" if Time.now.utc.to_i > payload["expires"].to_i

        reviewer = User.find_by_api_key(payload["api_key"])

        unless X::Signature.ok(reviewer.api_secret, payload)
          halt 401, "Unauthorized"
        end

        submission = Submission.find_by_key(payload["uuid"])

        comment = payload["comment"].to_s

        if comment.empty?
          halt 400, { error: "no comment submitted (submission: #{submission.key})" }.to_json
        end

        # The reviewer has already commented, ignore it.
        halt 204 if submission.comments.where(user_id: reviewer.id).count > 0

        # Only respond to the most recent iteration.
        uuid = Submission.where(user_exercise_id: submission.user_exercise_id).order('created_at DESC').limit(1).pluck('key').first
        halt 204 if uuid != submission.key

        c = submission.comments.create(user: reviewer, body: comment)
        ex = submission.user_exercise
        # If we're running against historical data, we don't want to flood
        # the inbox with ancient iterations.
        ex.update_last_activity(c).save if ex.last_activity_at > 1.week.ago
        ConversationSubscription.join(reviewer, submission)
        Notification.on(submission, user_id: submission.user, action: 'comment', actor_id: reviewer.id)
        halt 204
      end
    end
  end
end
