class Authentication
  def self.perform(code)
    id, username, email = Github.authenticate(code)
    User.from_github(id, username, email)
  end
end
