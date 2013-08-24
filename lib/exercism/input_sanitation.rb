require 'sanitize'

module InputSanitation
  def sanitize(input)
    return if input.nil?
    ::Sanitize.clean(input, Sanitize::Config::RELAXED)
  end
end
