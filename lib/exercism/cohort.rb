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

  def sees(exercise)
    managers + members.select do |member|
      sees?(member, exercise)
    end
  end

  private

  def sees?(member, exercise)
    member.completed?(exercise) || member.working_on?(exercise)
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
      managers.add team.creator
    end
    managers.delete user
  end

end
