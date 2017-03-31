class GithubUser
  attr_reader :id, :username, :email, :avatar_url

  def initialize(id, username, email, avatar_url)
    @id = id
    @username = username
    @email = email
    @avatar_url = avatar_url
  end
end
