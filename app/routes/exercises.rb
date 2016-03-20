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
        LifecycleEvent.track('completed', current_user.id)
        flash[:success] = "#{exercise.problem.name} in #{exercise.problem.track_id} is now archived."
        redirect '/'
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

      post '/exercises/delete' do
        exercises = current_user.exercises.find(params['exercise_ids'])
        exercises.each do |exercise|
          DeletedIterations.store_iterations(exercise, current_user.id)
          exercise.delete
        end
        flash[:success] = "Your exercises has been deleted"
        redirect "/#{current_user.username}"
      end

      get '/exercises/:track_id/:slug' do |id, slug|
        exercise = X::Exercise::TestFiles.find(id, slug)
        if exercise.files.empty?
          flash[:notice] = "No files for #{exercise.name} problem in #{exercise.language} track"
          redirect '/'
        end
        erb :"exercises/test_suite", locals: { exercise: exercise }
      end

      get '/exercises/:track_id/:slug/readme' do |id, slug|
        exercise = X::Exercise::Readme.find(id, slug)
        if exercise.readme.empty?
          flash[:notice] = "No files for #{exercise.name} problem in #{exercise.language} track"
          redirect '/'
        end
        erb :"exercises/readme", locals: { exercise: exercise }
      end
    end
  end
end
