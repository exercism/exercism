class Authentication
  def self.perform(code, client_id, client_secret, target_profile)
    access_token = Github.access_token(code, client_id, client_secret)
    result = Github.user_info(access_token)
    [User.from_github(*result), access_token]
  end
end
