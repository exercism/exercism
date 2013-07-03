class NitpickMessage < Message

  def subject
    "New nitpick from #{from}"
  end

  def template_name
    'nitpick'
  end

end
