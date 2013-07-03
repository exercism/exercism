class Message
  class SubclassMustOverride < StandardError; end

  attr_reader :instigator, :submission, :site_root

  def initialize(options)
    @instigator = options.fetch(:instigator)
    @submission = options.fetch(:submission)
    @site_root = options.fetch(:site_root)
    @intercept_emails = options.fetch(:intercept_emails) { false }
  end

  def recipient
    submission.user
  end

  def to
    recipient.email
  end

  def name
    recipient.username
  end

  def from
    instigator.username
  end

  def body
    ERB.new(template(template_name)).result binding
  end

  def template_name
    raise SubclassMustOverride
  end

  def subject
    raise SubclassMustOverride
  end

  def full_subject
    "[exercism.io] #{subject}"
  end

  def ship
    Email.new(
      to: to,
      subject: full_subject,
      body: body,
      intercept_emails: intercept_emails?,
    ).ship
    self
  end

  def intercept_emails?
    @intercept_emails
  end

  def template(name)
    File.read("./lib/services/email/#{name}.erb")
  end
end
