require 'api/stats/nit_streak'
require 'api/stats/submission_streak'

class ExercismAPI < Sinatra::Base
  get '/stats/:username/nitpicks/:year/:month' do |username, year, month|
    Api::Stats::NitStreak.for(username, year.to_i, month.to_i).to_json
  end

  get '/stats/:username/submissions/:year/:month' do |username, year, month|
    Api::Stats::SubmissionStreak.for(username, year.to_i, month.to_i).to_json
  end
end
