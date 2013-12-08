class Work
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def random
    shuffled.reduce(nil) do |acc, (language, slug)|
      acc || Pick.new(user, language, slug).choice
    end
  end

  private

  def shuffled
    user.nitpickables.to_a.shuffle.flat_map do |(language, slugs)|
      slugs = rand < 0.7 ? slugs.reverse : slugs.shuffle
      slugs.map { |slug| [language, slug] }
    end
  end

  class Pick
    def initialize(user, language, slug)
      @user = user
      @language = language
      @slug = slug
    end

    def choice
      choices.limit(1).offset(index).first
    end

    private
    attr_reader :user, :language, :slug

    def index
      DecayingRandomizer.new(choices.count).next
    end

    def choices
      @choices ||= Submission.pending.
        where(language: language, slug: slug).
        not_commented_on_by(user).not_liked_by(user).
        unmuted_for(user).
        order("updated_at DESC")
    end

  end
end
