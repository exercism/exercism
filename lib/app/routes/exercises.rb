module ExercismWeb
  module Routes
    class Exercises < Core
      get '/exercises/:key' do |key|
        exercise = UserExercise.find_by_key(key)
        if exercise.nil?
          flash[:notice] = "Couldn't find that exercise."
          redirect '/'
        end

        if exercise.submissions.empty?
          # We have orphan exercises at the moment.
          flash[:notice] = "That submission no longer exists."
          redirect '/'
        end
        redirect "/submissions/%s" % exercise.submissions.last.key
      end
    end
  end
end
