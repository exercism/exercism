require 'pony'

class Email
  def initialize options
    @to = options.fetch(:to)
    @name = options.fetch(:name)
    @subject = options.fetch(:subject)
    @body = options.fetch(:body)
  end

  def ship
    Pony.mail(params)
  end

  private
  def params
    if production_mode?
      send_to_human
    else
      send_to_mail_catcher
    end
  end

  def base_options
    {
      to: @to,
      from: "noreply@exercism.io",
      subject: @subject,
      body: @body
    }
  end

  def settings
    if production_mode?
      send_to_mail_catcher
    else
      send_to_humans
    end
  end

  def send_to_mail_catcher
    base_options.merge(
      via: :smtp,
      via_options: {
        :address => "localhost",
        :port => 1025
      }
    )
  end

  def send_to_humans
    base_options
  end

  def production_mode?
    !%w{development test}.include? ENV['RACK_ENV']
  end
end
