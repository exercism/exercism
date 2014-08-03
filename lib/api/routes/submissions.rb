module ExercismAPI
  module Routes
    class Submissions < Core
      get '/submissions/:key' do |key|
        submission = Submission.find_by_key(key)
        if submission.nil?
          halt 404, {error: "unknown submission #{key}"}.to_json
        end

        {language: submission.language, code: submission.code}.to_json
      end
    end
  end
end
