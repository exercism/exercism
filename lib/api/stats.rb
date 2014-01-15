require 'api/stats/nit_streak'

class ExercismAPI < Sinatra::Base
  get '/stats/:username/nitpicks/:year/:month' do |username, year, month|
    Api::Stats::NitStreak.for(username, year.to_i, month.to_i).to_json
  end
end
