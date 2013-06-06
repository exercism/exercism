Language = Struct.new(:name, :code_extension, :test_extension) do

  def to_sym
    name.to_sym
  end

  def to_s
    name
  end

end
