module ExercismWeb
  module Routes
    class Exercises < Core
      get '/exercises/next' do
        if current_user.guest?
          redirect '/'
        end

        inbox = ::Inbox.new(current_user,
                            session[:inbox] || current_user.default_language,
                            session[:inbox_slug])
        next_uuid = inbox.next_uuid(session[:inbox_exercise])
        redirect "/exercises/#{next_uuid}"
      end

      get '/exercises/:key' do |key|
        exercise = UserExercise.find_by_key(key)
        if exercise.nil?
          flash[:notice] = "Couldn't find that exercise."
          redirect '/'
        end
        session[:inbox_exercise] = exercise.id

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
    end
  end
end
