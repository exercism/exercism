class Signup

  attr_reader :user, :trail
  def initialize(user, trail)
    @user = user
    @trail = trail
  end

  def perform
    unless user.doing?(trail.language)
      user.do!(trail.first)
    end
  end

end

