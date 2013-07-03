class Dispatch

  def self.new_nitpick(options)
    nitpick = options[:nitpick]
    options = {
      intercept_emails: false,
      submission: nitpick.submission,
      from: nitpick.nitpicker.username,
      regarding: 'nitpick'
    }.merge(options)
    new(options).ship
  end

  attr_reader :to, :name, :from, :submission, :site_root, :regarding

  def initialize options
    @submission = options.fetch(:submission)
    submitter = submission.user
    @to = submitter.email
    @name = submitter.username
    @from = options.fetch(:from)
    @intercept_emails = options.fetch(:intercept_emails)
    @site_root = options.fetch(:site_root)
    @regarding = options.fetch(:regarding)
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

  def subject
    "[exercism.io] New #{regarding} from #{from}"
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
