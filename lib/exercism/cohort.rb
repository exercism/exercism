class Cohort
  def self.for(user)
    new(user)
  end

  attr_reader :user
  def initialize(user)
    @user = user
  end

  def users
    members | managers
  end

  def members
    @members ||= compute_members
  end

  def managers
    @managers ||= compute_managers
  end

  def sees(problem)
    managers + members.select do |member|
      sees?(member, problem)
    end
  end

  private

  def sees?(member, problem)
    member.completed?(problem) || member.working_on?(problem)
  end

  def compute_members
    members = Set.new
    user.teams.each do |team|
      members += team.members
    end
    members.delete user
  end

  def compute_managers
    managers = Set.new
    user.teams.each do |team|
      managers += team.managers
    end
    managers.delete user
  end

end
