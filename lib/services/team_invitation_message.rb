class TeamInvitationMessage < Message

  def subject
    "#{from} has invited you to join team #{team}"
  end

  def template_name
    'team_invitation'
  end

  def recipient
    @target.fetch(:invitee)
  end

  def team
    @target.fetch(:team_name)
  end

end
