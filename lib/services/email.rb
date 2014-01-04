require 'pony'

class Email
  def initialize options
    @to = options.fetch(:to)
    @from = options.fetch(:from)
    @subject = options.fetch(:subject)
    @body = options.fetch(:body)
    @intercept_emails = options.fetch(:intercept_emails)
    @html = options.fetch(:html) { false }
  end

  def ship
    Pony.mail(params)
  end

  private

  def params
    if @intercept_emails
      options_for_mailcatcher
    else
      options_for_humans
    end
  end

  def base_options
    options = {
      to: @to,
      from: @from,
      subject: @subject,
      body: @body
    }

    if @html
      options.merge(headers: { 'Content-Type' => 'text/html' })
    else
      options
    end
  end

  def options_for_mailcatcher
    base_options.merge(
      via: :smtp,
      via_options: {
        :address => "localhost",
        :port => 1025
      }
    )
  end

  def options_for_humans
    base_options.merge(
      :via => :smtp,
      :via_options => {
        :address => ENV.fetch('EMAIL_SMTP_ADDRESS'),
        :port => ENV.fetch('EMAIL_SMTP_PORT'),
        :domain => ENV.fetch('EMAIL_DOMAIN'),
        :user_name => ENV.fetch('EMAIL_USERNAME'),
        :password => ENV.fetch('EMAIL_PASSWORD'),
        :authentication => :plain,
        :enable_starttls_auto => true
      }
    )
  end
end
