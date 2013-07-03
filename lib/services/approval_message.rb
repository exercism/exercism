class ApprovalMessage < Message

  def subject
    "#{submission.exercise.name} in #{submission.exercise.language} was approved by #{from}"
  end

  def template_name
    'approval'
  end

end
