class SetupHelp
  attr_reader :language, :dir
  def initialize(language, dir="./assignments")
    @language = language
    @dir = dir
  end

  def to_s
    if File.exists?(file)
      File.read File.join(dir, language, 'SETUP.md')
    else
      ""
    end
  end

  private

  def file
    File.join(dir, language, 'SETUP.md')
  end
end
