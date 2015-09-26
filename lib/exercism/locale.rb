class UnknownLocale
  attr_reader :file, :extension
  def initialize(file, extension)
    @file = file
    @extension = extension
  end

  def language
    raise Exercism::UnknownLanguage.new(error_message)
  end

  private

  def error_message
    "Cannot determine which language `#{file}` is in. Is `#{extension}` a valid file extension?"
  end
end

Locale = Struct.new(:language, :code_extension, :test_extension) do

  def name
    language.to_s.capitalize
  end

  def to_sym
    language.to_sym
  end

  def to_s
    language
  end
end
