class Authentication
  def self.perform(code, client_id, client_secret)
    id, username, email, avatar_url = Github.authenticate(code, client_id, client_secret)
    User.from_github(id, username, email, avatar_url)
  end
end
