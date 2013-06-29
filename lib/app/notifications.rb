class Notifications
  def self.new_nitpick(options)
    to = options.fetch(:submitter).email
    name = options.fetch(:submitter).username
    nitpicker = options.fetch(:nitpick).nitpicker.username
    Email.ship({
      to: to,
      name: name,
      subject: "New Nitpick From #{nitpicker}",
    })
  end
end
