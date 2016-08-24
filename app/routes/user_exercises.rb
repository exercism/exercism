module ExercismWeb
  module Routes
    class UserExercises < Core
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

        if params[:redirect].to_s.empty?
          redirect ["", "tracks", exercise.track_id, "exercises"].join('/')
        end
        redirect params[:redirect]
      end

      post '/exercises/:key/archive' do |key|
        exercise = UserExercise.find_by_key(key)
        unless current_user.owns?(exercise)
          flash[:notice] = "Only the author may archive the exercise."
          redirect "/exercises/#{key}"
        end
        exercise.archive!
        flash[:success] = "#{exercise.problem.name} in #{exercise.problem.track_id} is now archived."
        redirect '/'
      end

      post '/exercises/archive' do
        exercises = current_user.exercises.find(params['exercise_ids'])
        exercises.each(&:archive!)

        flash[:success] = "Your exercises have been archived."
        redirect "/#{current_user.username}"
      end

      post '/exercises/:key/unarchive' do |key|
        exercise = UserExercise.find_by_key(key)
        unless current_user.owns?(exercise)
          flash[:notice] = "Only the author may reactivate the exercise."
          redirect "/exercises/#{key}"
        end
        exercise.unarchive!
        flash[:success] = "#{exercise.problem.name} in #{exercise.problem.track_id} is now reactivated."
        redirect '/dashboard'
      end

      post '/exercises/:key/request-for-help' do |key|
        exercise = UserExercise.find_by_key(key)
        unless current_user.owns?(exercise)
          flash[:notice] = "Only the author may request help."
          redirect '/'
        end
        exercise.request_help!
        flash[:success] = "You have requested help on this submission."
        redirect "/submissions/%s" % exercise.submissions.last.key
      end

      delete '/exercises/:key/request-for-help' do |key|
        exercise = UserExercise.find_by_key(key)
        unless current_user.owns?(exercise)
          flash[:notice] = "Only the author may cancel a request for help."
          redirect '/'
        end
        exercise.cancel_request_for_help!
        flash[:success] = "Your request for help has been cancelled."
        redirect "/submissions/%s" % exercise.submissions.last.key
      end

      post '/exercises/delete' do
        exercises = current_user.exercises.find(params['exercise_ids'])
        exercises.each do |exercise|
          DeletedIterations.store_iterations(exercise, current_user.id)
          exercise.delete
        end
        flash[:success] = "Your exercises have been deleted."
        redirect "/#{current_user.username}"
      end
    end
  end
end
