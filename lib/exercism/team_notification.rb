require 'exercism/notification'

class TeamNotification < Notification

  belongs_to :team, foreign_key: 'item_id'

  def team_name
    team.name
  end

  def username
    team.creator.username
  end

  def link
    "/account"
  end

  def icon
    "user"
  end
end

