class Github
  def self.authenticate(code)
    conn = Faraday.new(:url => 'https://github.com') do |c|
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end

    # Now that we know we're okay to connect, we have to request a bearer
    # token which is needed to request details as a user.
    options = {
      client_id: ENV.fetch('EXERCISM_GITHUB_CLIENT_ID'),
      client_secret: ENV.fetch('EXERCISM_GITHUB_CLIENT_SECRET'),
      code: code
    }
    response = conn.post do |req|
      req.url '/login/oauth/access_token'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['User-Agent'] = 'exercism v0.0.1.pre-alpha'
      req.body = options.to_json
    end
    access_token = JSON.parse(response.body)['access_token']

    conn = Faraday.new(:url => 'https://api.github.com') do |c|
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end

    # Now that we have a code and a bearer token, we can finally ask for
    # more details about the user. This will give us access to their
    # github id, their username, and their email.
    response = conn.get do |req|
      req.url '/user'
      req.headers['User-Agent'] = 'exercism v0.0.1.pre-alpha'
      req.params['access_token'] = access_token
    end
    result = JSON.parse(response.body)
    [result['id'], result['login'], result['email'], result['avatar_url']]
  end
end
