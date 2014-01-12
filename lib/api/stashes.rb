# TODO: remove this api. The functionality was removed
#       in januari 2014. At that point, it was not or barely
#       used already, should be safe to remove in April.
class ExercismAPI < Sinatra::Base
  post '/user/assignments/stash' do
    halt 410, "Stash functionality has been removed"
  end

  get '/user/assignments/stash' do
    halt 410, "Stash functionality has been removed"
  end

  get '/user/assignments/stash/list' do
    halt 410, "Stash functionality has been removed"
  end
end
