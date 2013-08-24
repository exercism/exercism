class ExercismApp < Sinatra::Base
  post '/api/v1/user/assignments/stash' do
    request.body.rewind
    data = request.body.read
    data = JSON.parse(data)
    unless data['key']
      halt 401, {error: "Please provide API key"}.to_json
    end
    user = User.find_by(key: data['key'])
    halt 401, "Unable to identify user" unless user
    stash = Stash.new(user, data['code'], data['filename']).save
    status 201
    pg :stash, locals: {stash: stash.submission}
  end

  get '/api/v1/user/assignments/stash' do
    unless params[:key]
      halt 401, {error: "Please provide API key"}.to_json
    end
    user = User.find_by(key: params[:key])
    filename = params[:filename]
    stash = Stash.new(user,' ',filename).find
    pg :stash, locals: {stash: stash}
  end

  get '/api/v1/user/assignments/stash/list' do
    user = User.find_by(key: params[:key])
    list = user.stash_list
    pg :stash_list, locals: {list: list}
  end
end