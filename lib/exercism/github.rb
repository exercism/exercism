class Github
  include Connection
  class UnauthorizedUser < StandardError; end
  USER_AGENT = 'github.com:exercism/exercism.io'

  def self.login_url(q)
    "https://github.com/login/oauth/authorize?#{q.map { |k, v| '%s=%s' % [k, v] }.join('&')}"
  end

  def self.user_info(access_token)
    conn = connect_to 'https://api.github.com'
    response = conn.get do |req|
      req.url '/user'
      req.headers['User-Agent'] = USER_AGENT
      req.params['access_token'] = access_token
    end
    raise UnauthorizedUser unless response.success?
    result = JSON.parse(response.body)
    GithubUser.new(result)
  end

  def initialize(code, client_id, client_secret)
    @code = code
    @client_id = client_id
    @client_secret = client_secret
  end

  def access_token
    conn = connect_to('https://github.com')

    response = conn.post do |req|
      req.url '/login/oauth/access_token'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['User-Agent'] = USER_AGENT
      req.body = { client_id: client_id, client_secret: client_secret, code: code }.to_json
    end
    JSON.parse(response.body)['access_token']
  end

  def user_info(access_token)
    self.class.user_info(access_token)
  end

  private
  attr_reader :code, :client_id, :client_secret
end
