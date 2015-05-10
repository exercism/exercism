# rubocop:disable Lint/HandleExceptions, Lint/RescueException
# Allow all exceptions to be reported to Bugsnag

require 'app/presenters/tracks'

class Language
  def self.of(key)
    ExercismWeb::Presenters::Tracks.find(key.to_s).language
  rescue Exception => e
    Bugsnag.notify(e)
    "No language for #{key}"
  end
end
