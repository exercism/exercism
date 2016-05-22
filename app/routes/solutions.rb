module ExercismWeb
  module Routes
    class Solutions < Core
      get '/code/:language/:slug/random' do |language, slug|
        please_login

        [language, slug].each(&:downcase!)

        problem = Problem.new(language, slug)
        unless current_user.access?(problem)
          flash[:notice] = "You'll have access to that when you submit #{problem.name} in #{problem.language}"
          redirect '/'
        end

        exercises = UserExercise.archived.for(problem)
        total = exercises.count
        if total == 0
          flash[:notice] = "No archived exercises for #{problem.name} in #{problem.language}"
          redirect '/'
        end

        erb :"code/random", locals: { submission: exercises.randomized.first.submissions.last, total: total }
      end
    end
  end
end
