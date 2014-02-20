require 'api/stats/nit_streak'
require 'api/stats/submission_streak'
require 'api/stats/snapshot'

class ExercismAPI < Sinatra::Base
  get '/stats/:username/nitpicks/:year/:month' do |username, year, month|
    Api::Stats::NitStreak.for(username, year.to_i, month.to_i).to_json
  end

  get '/stats/:username/submissions/:year/:month' do |username, year, month|
    Api::Stats::SubmissionStreak.for(username, year.to_i, month.to_i).to_json
  end

  get '/stats/:username/snapshot' do |username|
    user = User.find_by_username(username)
    if !user
      halt 400, {error: "Unknown user #{username}"}
    end
    snapshot = Api::Stats::Snapshot.new(user)
    pg :"stats/snapshot", locals: {snapshot: snapshot}
  end
end
