Locale = Struct.new(:language, :code_extension, :test_extension) do

  def to_sym
    language.to_sym
  end

  def to_s
    language
  end

end
