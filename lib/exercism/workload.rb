class Workload
  def self.for(user, language = nil, slug = nil)
    new(user, language, slug)
  end

  attr_reader :user, :language, :slug
  def initialize(user, language, slug)
    @user = user
    @language = language
    @slug = slug
  end

  def pending
    @pending ||= scope.or(default_criteria).and(trail_criteria).asc(:at)
  end

  def submissions
    return @submissions if @submissions

    result = []
    result.concat nitless
    result.concat wants_opinions
    result.concat recent
    result.concat pending.reverse
    @submissions = result.uniq
  end

  def nitless
    return @nitless if @nitless

    @nitless = pending.select {|submission|
      submission.no_nits_yet?
    }
  end

  def liked
    @liked ||= pending.and(is_approvable: true)
  end

  def wants_opinions
    @wants_opinions ||= pending.and(wants_opinions: true)
  end

  def featured
    return @featured if @featured

    @featured = []
    @featured.concat liked if user.locksmith?
    @featured.concat nitless
    @featured.concat wants_opinions
    @featured.uniq
  end

  private

  def scope
    @scope ||= Submission.pending
  end

  def recent
    @recent ||= pending.and(:at.gte => Date.today - 14)
  end

  def trail_criteria
    return @trail_criteria if @trail_criteria

    criteria = []
    criteria << {l: language} if language
    criteria << {s: slug} if slug
    @trail_criteria = criteria
  end

  def default_criteria
    return @default_criteria if @default_criteria

    criteria = []
    if user.master?
      criteria << {l: {"$in" => user.mastery}}
    end
    user.completed.each do |language, slugs|
      criteria << {l: language, slug: {"$in" => slugs}}
    end
    @default_criteria = criteria
  end
end

