module ExercismAPI
  module Routes
    class Submissions < Core
      # Return the URL of the most recent iteration.
      # Called by the CLI.
      get '/submissions/:language/:slug' do |language, slug|
        require_key

        if current_user.guest?
          halt 401, { error: "Please double-check your exercism API key." }.to_json
        end

        key = current_user.submissions.where(language: language, slug: slug).order('id DESC').limit(1).pluck(:key).first
        if key.nil?
          halt 404, { error: "No solutions found for exercise '#{slug}' in #{language}" }.to_json
        end

        { url: "#{request.scheme}://#{request.host_with_port}/submissions/#{key}", track_id: language, slug: slug }.to_json
      end

      # Download a solution, by key.
      # Called from the CLI.
      get '/submissions/:key' do |key|
        submission = Submission.find_by_key(key)
        if submission.nil?
          halt 404, { error: "unknown submission #{key}" }.to_json
        end

        implementation = Trackler.tracks[submission.language].implementations[submission.slug]
        if implementation.nil?
          halt 404, { error: "#{submission.slug} in #{submission.track_id} not found" }.to_json
        end

        {
          language: submission.language,
          track_id: submission.track_id,
          slug: submission.slug,
          uuid: submission.key,
          solution_uuid: submission.user_exercise.key,
          user_id: submission.user_id,
          username: submission.user.username,
          problem_files: implementation.files,
          solution_files: submission.solution,
        }.to_json
      end
    end
  end
end
