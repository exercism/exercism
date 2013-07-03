class Dispatch

  def self.new_nitpick(options)
    nitpick = options[:nitpick]
    options = {
      intercept_emails: false,
      submission: nitpick.submission,
      from: nitpick.nitpicker.username,
      subject: "New nitpick from #{nitpick.nitpicker.username}"
    }.merge(options)
    new(options).ship
  end

  attr_reader :to, :name, :from, :submission, :site_root, :subject

  def initialize options
    @submission = options.fetch(:submission)
    submitter = submission.user
    @to = submitter.email
    @name = submitter.username
    @from = options.fetch(:from)
    @intercept_emails = options.fetch(:intercept_emails)
    @site_root = options.fetch(:site_root)
    @subject = "[exercism.io] #{options.fetch(:subject)}"
  end

  def ship
    Email.new(
      to: to,
      subject: subject,
      body: body,
      intercept_emails: @intercept_emails,
    ).ship
    self
  end

  def body
    ERB.new(template('nitpick')).result binding
  end

  def template(name)
    File.read("./lib/services/email/#{name}.erb")
  end

  def submission_url
    "#{site_root}/user/submissions/#{submission.id}"
  end
end
