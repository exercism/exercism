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
    [user, access_token]
  end

  private

  attr_reader :code, :client_id, :client_secret, :target_profile

  def github
    @github ||= Github.new(code, client_id, client_secret)
  end

  def access_token
    @access_token ||= github.access_token
  end

  def user
    User.from_github(github_user.id, github_user.username, github_user.email, github_user.avatar_url, target_profile)
  end

  def github_user
    github.user_info(access_token)
  end
end
