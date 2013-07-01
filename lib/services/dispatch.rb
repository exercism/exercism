class Dispatch
  attr_reader :to, :name, :from, :submission
  def self.new_nitpick options
    new options
  end

  private
  def initialize options
    submitter = options.fetch(:submitter)
    nitpick = options.fetch(:nitpick)
    @to = submitter.email
    @name = submitter.username
    @from = nitpick.nitpicker.username
    @submission = nitpick.submission
    make_with_the_email
  end

  def make_with_the_email
    Email.new(
      to: @to,
      name: @name,
      subject: subject,
      body: body,
    ).ship
  end

  def subject regarding = "Nitpick"
    "New #{regarding} From #{@from}"
  end

  #TODO erb
  def body
    <<-eos
      Hi #{@name},
      Your submission has recived feedback from #{@from}! Visit #{submission_url} to find out more.
    eos
  end

  def submission_url
    "#{site_root}/user/submissions/#{@submission.id}"
  end

  def site_root
    if development_mode?
      "http://localhost:4567"
    else
      "http://exercism.io"
    end
  end

  def development_mode?
    ENV['RACK_ENV'] == "development"
  end
end
