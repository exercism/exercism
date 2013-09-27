class ExercismAPI < Sinatra::Base
  post '/user/assignments/stash' do
    request.body.rewind
    data = request.body.read
    data = JSON.parse(data)
    unless data['key']
      halt 401, {error: "Please provide API key"}.to_json
    end
    user = User.where(key: data['key']).first
    halt 401, "Unable to identify user" unless user
    stash = Stash.new(user, data['code'], data['filename']).save
    status 201
    pg :stash, locals: {stash: stash.submission}
  end

  get '/user/assignments/stash' do
    require_user
    filename = params[:filename]
    stash = Stash.new(current_user,' ',filename).find
    pg :stash, locals: {stash: stash}
  end

  get '/user/assignments/stash/list' do
    require_user
    list = current_user.stash_list
    pg :stash_list, locals: {list: list}
  end
end
