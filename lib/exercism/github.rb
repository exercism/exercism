module Github
  def self.login_url(client_id)
    "https://github.com/login/oauth/authorize?client_id=#{client_id}"
  end

  def self.connect_to(url)
    Faraday.new(url: url) do |c|
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end
  end

  def self.authenticate(code, client_id, client_secret)
    conn = connect_to('https://github.com')

    response = conn.post do |req|
      req.url '/login/oauth/access_token'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['User-Agent'] = user_agent
      req.body = {client_id: client_id, client_secret: client_secret, code: code}.to_json
    end
    access_token = JSON.parse(response.body)['access_token']

    conn = connect_to 'https://api.github.com'
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

  def self.configure_octokit
    Octokit.configure do |c|
      c.login = "SaiPramati"
      c.password = "pramati123"
    end
  end
end
