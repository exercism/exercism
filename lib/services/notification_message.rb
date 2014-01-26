class NotificationMessage < Message
  include Sinatra::FuzzyTimeHelper

  def initialize(options)
    @user = options.fetch(:user)
    @intercept_emails = options.fetch(:intercept_emails) { false }
    @site_root = options.fetch(:site_root) { 'http://exercism.io' }
  end

  def subject
    # "You have 5 notifications"
    "You have #{notifications.count} #{'notification'.pluralize(notifications.count)}"
  end

  def recipient
    @user
  end

  def template_name
    'notifications'
  end

  def html_body
    ERB.new(template('notifications.html')).result binding
  end

  def ship
    return false unless send_email?
    Email.new(
      to: to,
      from: from_email,
      subject: full_subject,
      body: body,
      html_body: html_body,
      intercept_emails: intercept_emails?
    ).ship
    self
  end

  private

  def subject_pluralize(count, word)
    "#{count} #{word.pluralize(count)}"
  end

  def send_email?
    notifications.count > 0
  end

  def pending_submissions
    pending_submissions = []
    @user.nitpicker_languages.each do |language|
      pending_submissions << Workload.new(@user, language, 'no-nits').submissions.limit(5)
    end
    pending_submissions.flatten
  end

  def notifications
    @user.notifications.on_submissions.unread.recent.by_recency
  end

end
