# rubocop:disable Lint/HandleExceptions, Lint/RescueException
# Allow all exceptions to be reported to Bugsnag

require_relative '../../app/presenters/tracks'

class Language
  def self.of(key)
    ExercismWeb::Presenters::Tracks.find(key.to_s).language
  rescue Exception => e
    Bugsnag.notify(e, {track: key})
    key
  end
end
