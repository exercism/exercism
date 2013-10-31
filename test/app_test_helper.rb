module AppTestHelper
  def login(user)
    {'rack.session' => { github_id: user.github_id }}
  end
end
