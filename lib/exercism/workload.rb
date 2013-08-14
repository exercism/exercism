class Workload
  def self.for(user)
    new(user)
  end

  attr_reader :user
  def initialize(user)
    @user = user
  end

  def scope
    return @scope if @scope

    @scope = Submission.pending
  end

  def pending
    @pending ||= scope.or(default_criteria)
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

  private

  def default_criteria
    return @default_criteria if @default_criteria

    criteria = []
    if user.master?
      criteria << {language: {"$in" => user.mastery}}
    end
    user.completed.each do |language, slugs|
      criteria << {language: language, slug: {"$in" => slugs}}
    end
    @default_criteria = criteria
  end
end

