module ExercismWeb
  module Routes
    class Solutions < Core
      get '/code/:language/:slug/random' do |language, slug|
        please_login

        language, slug = language.downcase, slug.downcase

        problem = Problem.new(language, slug)

        unless current_user.nitpicker_on?(problem)
          flash[:notice] = "You'll have access to that page when you complete #{slug} in #{language}"
          redirect '/'
        end

        submission = Submission.random_completed_for(problem)
        total = Submission.completed_for(problem).count

        if submission.problem.nil?
          # Need more info
          Bugsnag.notify("WARN: unknown problem for submission #{submission.key}")
          # try again
          redirect "/code/%s/%s/random" % [language, slug]
        end

        erb :"code/random", locals: {submission: submission, total: total}
      end
    end
  end
end
