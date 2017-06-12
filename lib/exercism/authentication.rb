class Authentication
  def self.perform(code, client_id, client_secret, target_profile)
    new(code, client_id, client_secret, target_profile).authenticate
  end

  def initialize(code, client_id, client_secret, target_profile)
    @code = code
    @client_id = client_id
    @client_secret = client_secret
    @target_profile = target_profile
  end

  def authenticate
    user
  end

  private

  attr_reader :code, :client_id, :client_secret, :target_profile

  def github_auth
    @github ||= GitHubAuth.new(code, client_id, client_secret)
  end

  def access_token
    @access_token ||= github_auth.access_token
  end

  def user
    User.from_authentication_data(github_user, target_profile)
  end

  def github_user
    GitHubAuth.user_info(access_token)
  end
end
