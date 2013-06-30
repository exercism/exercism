class Notifications
  def self.new_nitpick(options)
    to = options.fetch(:submitter).email
    name = options.fetch(:submitter).username
    nitpicker = options.fetch(:nitpick).nitpicker.username
    email = Email.new(
      to: to,
      name: name,
      subject: subject(nitpicker),
      body: body(name, nitpicker),
    ).ship
  end

  def self.subject(from, regarding = "Nitpick")
    "New #{regarding} From #{from}"
  end

  def self.body name, from
    <<-eos
      Hi #{name},
      Your submission has recived feedback from #{from}! Visit exercism.io to find out more.
    eos
  end
end
