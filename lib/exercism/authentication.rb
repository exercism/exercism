class Authentication
  def self.perform(code)
    id, username, email, avatar_url = Github.authenticate(code)
    User.from_github(id, username, email, avatar_url)
  end
end
