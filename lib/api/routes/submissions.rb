module ExercismAPI
  module Routes
    class Submissions < Core
      get '/submissions/:key' do |key|
        submission = Submission.find_by_key(key)
        if submission.nil?
          halt 404, {error: "unknown submission #{key}"}.to_json
        end

        status, payload = Xapi.get("v2", "exercises", submission.track_id, submission.slug)
        if status != 200
          halt status, payload
        end

        begin
          data = JSON.parse(payload)
        rescue
          halt 500, {error: "cannot get problem #{submission.slug} in #{submission.track_id}"}.to_json
        end

        problems = data['problems']
        if problems.nil?
          halt 404, {error: "#{submission.slug} in #{submission.track_id} not found"}.to_json
        end

        exercise = problems.first
        if exercise.nil?
          halt 404, {error: "#{submission.slug} in #{submission.track_id} not found"}.to_json
        end

        {
          language: exercise['language'],
          track_id: submission.track_id,
          slug: submission.slug,
          username: submission.user.username,
          problem: exercise['files'],
          solution: {submission.filename => submission.code}
        }.to_json
      end
    end
  end
end
