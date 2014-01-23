class Github
  def self.login_url(client_id)
    "https://github.com/login/oauth/authorize?client_id=#{client_id}"
  end

  def self.authenticate(code, client_id, client_secret)
    conn = Faraday.new(:url => 'https://github.com') do |c|
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end

    response = conn.post do |req|
      req.url '/login/oauth/access_token'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['User-Agent'] = user_agent
      req.body = {client_id: client_id, client_secret: client_secret, code: code}.to_json
    end
    access_token = JSON.parse(response.body)['access_token']

    conn = Faraday.new(:url => 'https://api.github.com') do |c|
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end

    response = conn.get do |req|
      req.url '/user'
      req.headers['User-Agent'] = user_agent
      req.params['access_token'] = access_token
    end
    result = JSON.parse(response.body)
    [result['id'], result['login'], result['email'], result['avatar_url']]
  end

  def self.user_agent
    'github.com:exercism/exercism.io'
  end
end
