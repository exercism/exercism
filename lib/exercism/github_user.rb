class GitHubUser
  attr_reader :id, :username, :email, :avatar_url

  def initialize(attributes)
    @id         = attributes.fetch('id')
    @username   = attributes.fetch('login')
    @email      = attributes.fetch('email')
    @avatar_url = attributes.fetch('avatar_url')
  end
end
