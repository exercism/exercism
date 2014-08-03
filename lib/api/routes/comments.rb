require 'exercism/rikki'

module ExercismAPI
  module Routes
    class Comments < Core
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
          halt 400, {error: "cannot find rikki- the robot - #{key}"}.to_json
        end

        body = params[:body].to_s.strip
        if body.empty?
          halt 400, {error: "no body submitted - #{key}"}.to_json
        end

        submission.comments.create(user: user, body: body)
        halt 204
      end
    end
  end
end
