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
    (progression & events).last || 'guest'
  end

  def self.step(events)
    progression.index(status(events)) || -1
  end

  def self.next_action(events)
    case step(events)
    when ->(i) { i < 1 }
      ProgressBar::StepInstall
    when ->(i) { i < 2 }
      ProgressBar::StepSubmit
    when ->(i) { i < 4 }
      ProgressBar::StepDiscuss
    when ->(i) { i < 5 }
      ProgressBar::StepNitpick
    else
      ProgressBar::StepExplore
    end
  end

  def self.current_step(events)
    case step(events)
    when ->(i) { i < 1 }
      ProgressBar::StepInstall
    when ->(i) { i < 2 }
      ProgressBar::StepSubmit
    when ->(i) { i < 4 }
      ProgressBar::StepDiscuss
    when ->(i) { i < 6 }
      ProgressBar::StepNitpick
    else
      ProgressBar::StepExplore
    end
  end
end
