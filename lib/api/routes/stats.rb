module ExercismAPI
  module Routes
    class Stats < Core
      get '/stats/:username/snapshot' do |username|
        user = User.find_by_username(username)
        if !user
          halt 400, {error: "Unknown user #{username}"}
        end
        snapshot = ::Stats::Snapshot.new(user)
        pg :"stats/snapshot", locals: {snapshot: snapshot}
      end
    end
  end
end
