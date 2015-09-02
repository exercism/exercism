class Cohort
  def self.for(user)
    new(user)
  end

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def sees(problem)
    (other_users(problem) + managers).uniq {|u| u.id}
  end

  def team_members_and_managers
    fetch_user_records(confirmed_team_member_ids + team_manager_ids)
  end

  def members
    fetch_user_records confirmed_team_member_ids
  end

  def managers
    fetch_user_records team_manager_ids
  end

  private

  def fetch_user_records(ids)
    User.where(id: ids)
  end

  def other_users(problem)
    members.includes(:submissions).where(:submissions => {language: problem.track_id, slug: problem.slug}).references(:submissions)
  end

  def confirmed_team_member_ids
    TeamMembership.confirmed.where(team_id: team_ids).where.not(user_id: @user.id).pluck(:user_id)
  end

  def team_member_ids
    TeamMembership.where(team_id: team_ids).where.not(user_id: @user.id).pluck(:user_id)
  end

  def team_manager_ids
    TeamManager.where(team_id: team_ids).where.not(user_id: @user.id).pluck(:user_id)
  end

  def team_ids
    @team_ids = user.team_memberships.pluck(:team_id).uniq if @team_ids.nil?
    @team_ids
  end

end
