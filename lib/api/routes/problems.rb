module ExercismAPI
  module Routes
    class Problems < Core
      get '/problems' do
        require_key

        if current_user.guest?
          halt 400, {error: "Unknown user."}.to_json
        end

        q = current_user.exercises
        if params[:language].present?
          q = q.where(language: params[:language])
        end
        if params[:state].present?
          q = q.where(state: params[:state])
        end
        # TODO: eventually we should paginate, but there
        # really isn't all that much data, yet.
        pg :problems, locals: {exercises: q}
      end
    end
  end
end
