class Launch

  attr_reader :user, :language
  def initialize(user, language)
    @user = user
    @language = language
  end

  def start
    unless curriculum.available?(language)
      fail Exercism::UnknownLanguage
    end
    user.do! curriculum.in(language).first
  end

  def curriculum
    Exercism.current_curriculum
  end

end

