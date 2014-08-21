class ProgressBar
  StepInstall = "install-cli"
  StepSubmit = "submit-code"
  StepDiscuss = "have-a-conversation"
  StepNitpick = "pay-it-forward"
  StepExplore = "explore"

  def self.steps
    [StepInstall, StepSubmit, StepDiscuss, StepNitpick, StepExplore]
  end

  def self.fill?(step, current)
    steps.index(step) < steps.index(current)
  end

  def self.status(step, current)
    if fill?(step, current)
      "visited"
    else
      "todo"
    end
  end
end
