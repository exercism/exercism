require 'api/stats/nitstreak'

class ExercismAPI < Sinatra::Base
  get '/stats/:username/nitpicks/:year/:month' do |username, year, month|
    Api::Stats::Nitstreak.for(username, year.to_i, month.to_i).to_json
  end
end
