require 'pony'

class Email
  def initialize options
    @to = options.fetch(:to)
    @name = options.fetch(:name)
    @subject = options.fetch(:subject)
    @body = options.fetch(:body)
    @intercept_emails = options.fetch(:intercept_emails)
  end

  def ship
    Pony.mail(params)
  end

  private
  def params
    if @intercept_emails
      options_for_mail_catcher
    else
      options_for_human
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

  def options_for_mail_catcher
    base_options.merge(
      via: :smtp,
      via_options: {
        :address => "localhost",
        :port => 1025
      }
    )
  end

  def options_for_humans
    base_options
  end
end
