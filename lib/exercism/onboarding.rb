class Onboarding
  def self.progression
    %w(
      joined
      fetched
      submitted
      received_feedback
      completed
      commented
      onboarded
    )
  end

  def self.status(events)
    (progression & events).last
  end

  def self.step(events)
    progression.index(status(events))
  end
end
