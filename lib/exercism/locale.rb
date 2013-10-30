class Exercism
  class UnknownLanguage < StandardError; end
end

class UnknownLocale
  attr_reader :file, :extension
  def initialize(file, extension)
    @file, @extension = file, extension
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

  def test_directory
    "."
  end

  def additional_files
    []
  end

end

class ScalaLocale < Locale
  def test_directory
    "src/test/scala"
  end

  def additional_files
    ["build.sbt"]
  end
end
