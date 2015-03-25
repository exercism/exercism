require 'app/helpers/fuzzy_time'

class NotificationMessage < Message
  include ExercismWeb::Helpers::FuzzyTime

  def initialize(options)
    @user = options.fetch(:user)
    @intercept_emails = options.fetch(:intercept_emails) { false }
    @site_root = options.fetch(:site_root) { 'http://exercism.io' }
  end

  def notifications_count
    # "5 notifications"
    "#{unread_notifications.count} #{'notification'.pluralize(notifications.count)}"
  end

  def subject
    # "You have 5 notifications"
    "You have #{notifications_count}"
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
    unread_notifications.count > 0
  end

  def pending_submissions
    @pending_submissions ||= @user.nitpicker_languages.map do |language|
      Workload.new(@user, language, 'no-nits').submissions.limit(5)
    end.flatten - unread_submissions
  end

  def unread_notifications
    @unread_notifications ||= @user.notifications.on_submissions.unread.recent.by_recency
  end

  def unread_submissions
    @unread_submissions ||= unread_notifications.map(&:submission)
  end

  def notifications
    unread_notifications.limit(5)
  end

  def truncated?
    unread_notifications.count > notifications.count
  end

  def from(user)
    user ? "from: #{user.username}" : ""
  end
end
