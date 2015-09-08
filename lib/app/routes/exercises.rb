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

      post '/exercises/:key/views' do |key|
        if current_user.guest?
          # silently ignore the request
          redirect '/'
        end

        exercise = UserExercise.find_by_key(key)
        if exercise.nil?
          flash[:notice] = "Couldn't find that exercise."
          redirect '/'
        end

        exercise.viewed_by(current_user)

        redirect ["", "tracks", exercise.track_id, "exercises"].join('/')
      end
    end
  end
end
