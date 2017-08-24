class Authentication
  def self.perform(code, client_id, client_secret, target_profile)
    id, username, email, avatar_url, bio, name = Github.authenticate(code, client_id, client_secret)
    User.from_github(id, username, email, avatar_url, bio, name, target_profile)
  end
end
