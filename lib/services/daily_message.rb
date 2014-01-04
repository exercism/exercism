class DailyMessage < Message
  include Sinatra::FuzzyTimeHelper

  def initialize(options)
    @user = options.fetch(:user)
    @intercept_emails = options.fetch(:intercept_emails) { false }
    @site_root = options.fetch(:site_root) { 'http://exercism.io' }
    @html = true
  end

  def subject
    subject = []
    if notifications.count > 0
      subject << subject_pluralize(notifications.count, 'notification')
    end

    if pending_submissions.count > 0
      subject << subject_pluralize(pending_submissions.count, 'submission') + ' needing review'
    end

    "Daily Digest: #{subject.join(', ')}"
  end

  def ship
    send_email? ? super : false
  end

  def recipient
    @user
  end

  def template_name
    'daily'
  end

  private

  def subject_pluralize(count, word)
    "#{count} #{word.pluralize(count)}"
  end

  def send_email?
    notifications.count > 0 || pending_submissions.count > 0
  end

  def pending_submissions
    pending_submissions = []
    @user.nitpicker_languages.each do |language|
      pending_submissions << Workload.new(@user, language, 'no-nits').submissions.limit(5)
    end
    pending_submissions.flatten
  end

  def notifications
    @user.notifications.unread.by_recency
  end

end
