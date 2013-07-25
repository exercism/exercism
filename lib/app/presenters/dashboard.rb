class Dashboard

  class Filters
    attr_reader :submissions

    def initialize(submissions)
      @submissions ||= submissions
    end

    def users
      @users ||= submissions.map {|sub| sub.user.username}.uniq.sort
    end

    def exercises
      @exercises ||= submissions.map(&:slug).uniq.sort
    end

    def languages
      @languages ||= submissions.map(&:language).uniq.sort
    end
  end

  class Submissions
    attr_reader :submissions
    def initialize(submissions)
      @submissions = submissions
    end

    def all
      pending
    end

    def any?
      not all.empty?
    end

    def pending
      submissions
    end

    def without_nits
      @without_nits ||= pending.select { |sub| sub.nits.count.zero? }.reverse
    end

    def with_nits
      @with_nits ||= pending.select { |sub| !sub.nits.count.zero? }
    end

    def flagged_for_approval
      []
    end
  end

  class AdminSubmissions < Submissions
    def all
      submissions
    end

    def pending
      @pending ||= submissions.select { |sub| !sub.approvable? }
    end

    def flagged_for_approval
      @flagged_for_approval ||= submissions.select { |sub| sub.approvable? }
    end
  end

  attr_reader :user, :all_submissions
  def initialize(user, all_submissions)
    @user = user
    @all_submissions = all_submissions
  end

  def submissions
    if user.admin?
      @submissions ||= AdminSubmissions.new(all_submissions)
    else
      @submissions ||= Submissions.new(all_submissions)
    end
  end

  def filters
    @filters ||= Filters.new(submissions.all)
  end
end

