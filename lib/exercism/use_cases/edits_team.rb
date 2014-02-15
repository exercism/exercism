class EditsTeam
  attr_reader :context

  def initialize(context)
    @context = context
  end

  def update(slug, attrs)
    team = Team.find_by_slug(slug)

    if team.defined_with(attrs).save
      context.team_updated(team.slug)
    else
      context.team_invalid(slug)
    end
  end
end
