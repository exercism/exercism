class Onboarding
  def self.progression
    %w(
      joined
      fetched
      submitted
      received_feedback
      completed
      commented
    )
  end

  def self.status(events)
    (progression & events).last
  end
end
