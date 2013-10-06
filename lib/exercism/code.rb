class Code

  attr_reader :path, :locales
  def initialize(path, locales)
    @path = path
    @locales = locales
  end

  def language
    locale.language
  end

  def filename
    @filename ||= path_segments.last
  end

  def extension
    @extension ||= filename[/([^\.]+)\Z/, 1]
  end

  def slug
    path_segments[-2]
  end

  private

  def path_segments
    @path_segments = path.split(/\/|\\/)
  end

  def identify_locale
    locales.find {|settings| settings.code_extension == extension}
  end

  def locale
    @locale ||= identify_locale || UnknownLocale.new(filename, extension)
  end
end

