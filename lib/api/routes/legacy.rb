module ExercismAPI
  module Routes
    class Legacy < Core
      # Last used in CLI v2.0.2.
      # Deprecated April 27, 2015
      get '/user/assignments/restore' do
        halt *Xapi.get("exercises", "restore", key: params[:key])
      end
    end
  end
end

